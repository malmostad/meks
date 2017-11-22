class SamlController < ApplicationController
  before_action :reset_session_keys, only: [:consume, :sso, :logout]
  skip_authorize_resource
  skip_authorization_check
  skip_before_action :authenticate

  skip_before_action :verify_authenticity_token, only: [:consume, :logout]

  layout 'login'

  def sso
    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(saml_settings))
  end

  def consume
    begin
      response = OneLogin::RubySaml::Response.new(params[:SAMLResponse], settings: saml_settings)

      if response.is_valid?
        # Check if user belongs to a system group in the LDAP
        @ldap = Ldap.new
        cn = response.name_id
        role = @ldap.belongs_to_group(cn)

        if !role.present?
          logger.info "[SAML_AUTH] #{cn} from #{client_ip} failed to log in: doesn't belong to a group."
          @error_message = 'Du saknar behörighet till systemet.'
          render :fail
        else
          # Update system information for user with LDAP data
          user = @ldap.update_user_profile(cn, role, client_ip)

          # Establish session and redirect to the page requested by user
          session[:user_id] = user.id
          logger.info "[SAML_AUTH] #{user.username} logged in from #{client_ip}"
          update_session
          redirect_after_login
        end
      else
        logger.error "[SAML_AUTH] Response Invalid. Errors: #{response.errors}. IP: #{client_ip}. SAML response:"
        @error_message = 'Inloggning med SAML misslyckades.'
        render :fail
      end
    rescue => e
      logger.fatal "[SAML_AUTH] SAML response for #{client_ip} failed. #{e.message}"
      logger.fatal e.backtrace.inspect
      @error_message = 'Inloggning med SAML misslyckades.'
      render :fail
    end
  end

  def metadata
    meta = OneLogin::RubySaml::Metadata.new
    render xml: meta.generate(saml_settings, true)
  end

  def logout
    # Placeholder for SAML SLO implementation
    reset_session_keys
    redirect_to root_path, notice: 'Du är utloggad från MEKS'
  end

  private

  def base_url
    "#{request.protocol}#{request.host}"
  end

  def saml_settings
    @config = Rails.application.secrets.saml

    # Metadata URI settings
    # Returns OneLogin::RubySaml::Settings prepopulated with idp metadata
    # idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
    # settings = idp_metadata_parser.parse_remote @config[:idp_metadata]

    settings = OneLogin::RubySaml::Settings.new
    settings.issuer                         = base_url
    settings.idp_sso_target_url             = @config[:idp_sso_target_url]
    settings.assertion_consumer_service_url = "#{base_url}/saml/consume"

    # Non-metadata URI settings
    # settings.idp_cert                       = @config[:idp_cert]
    settings.idp_cert_fingerprint           = @config[:idp_cert_fingerprint]
    settings.idp_cert_fingerprint_algorithm = 'http://www.w3.org/2000/09/xmldsig#sha1'
    settings.name_identifier_format         = 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress'
    settings.authn_context                  = 'urn:oasis:names:tc:SAML:2.0:ac:classes:MobileTwoFactorUnregistered'
    settings.compress_request               = false

    # setting.security (signing) is documented at https://github.com/onelogin/ruby-saml#signing

    settings
  end
end
