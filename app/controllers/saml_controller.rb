class SamlController < ApplicationController
  skip_authorize_resource
  skip_authorization_check
  skip_before_action :authenticate

  skip_before_action :verify_authenticity_token, only: [:consume, :logout]

  def sso
    auth_request = OneLogin::RubySaml::Authrequest.new
    redirect_to(auth_request.create(saml_settings))
  end

  def consume
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse], settings: saml_settings)

    # debug_response(response)

    if response.is_valid?
      session[:nameid] = response.nameid
      logger.info "[SAML_AUTH] #{response.nameid} logged in from #{client_ip}"
      redirect_after_login
    else
      logger.info "[SAML_AUTH] #{response.nameid} from #{client_ip} failed to log in"
      logger.info "[SAML_AUTH] Response Invalid. Errors: #{response.errors}"
      @errors = response.errors
      # TODO: redirect user with a helpful message
    end
  end

  def metadata
    meta = OneLogin::RubySaml::Metadata.new
    render xml: meta.generate(saml_settings, true)
  end

  def base_url
    "#{request.protocol}#{request.host}"
  end

  def saml_settings
    @config = Rails.application.secrets.saml

    # Metadata URI settings
    # Returns OneLogin::RubySaml::Settings prepopulated with idp metadata
    #settings = OneLogin::RubySaml::IdpMetadataParser.new.idp_metadata_parser.parse_remote(@config['idp_metadata'])

    settings = OneLogin::RubySaml::Settings.new
    settings.idp_sso_target_url             = @config['idp_sso_target_url']
    settings.idp_slo_target_url             = @config['idp_slo_target_url']

    settings.assertion_consumer_service_url = "#{base_url}/saml/consume"
    settings.issuer                         = "#{base_url}/saml/metadata"

    # Non-metadata URI settings
#     settings.idp_cert                       = "-----BEGIN CERTIFICATE-----
# #{@config['idp_cert']}
# -----END CERTIFICATE-----"

    settings.idp_cert_fingerprint           = @config['idp_cert_fingerprint']
    settings.idp_cert_fingerprint_algorithm = "http://www.w3.org/2000/09/xmldsig#sha1"
    settings.name_identifier_format         = "urn:oasis:names:tc:SAML:2.0:nameid-format:emailAddress"

    # # Optional for most SAML IdPs
    # settings.authn_context = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
    # # Optional bindings (defaults to Redirect for logout POST for consume)
    # settings.assertion_consumer_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
    # settings.assertion_consumer_logout_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"

    # setting.security (signing) is documented at https://github.com/onelogin/ruby-saml#signing

    settings
  end

  def debug_response(response)
    logger.debug '=' * 72
    logger.debug 'SAML response:'

    doc = Nokogiri::XML(Base64.decode64(response))
    Base64.encode64(doc.root.to_s)

    cert = doc.xpath('//ds:X509Certificate', 'ds' => 'http://www.w3.org/2000/09/xmldsig#')
    cert.first.content = cert.first.content.gsub!(/\s/, '')

    signature = doc.xpath('//ds:SignatureValue', 'ds' => 'http://www.w3.org/2000/09/xmldsig#')
    signature.first.content = signature.first.content.gsub!(/\s/, '')

    modulus = doc.xpath('//ds:Modulus', 'ds' => 'http://www.w3.org/2000/09/xmldsig#')
    modulus.first.content = modulus.first.content.gsub!(/\s/, '')

    logger.debug '=' * 72
  end
end
