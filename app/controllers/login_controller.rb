class LoginController < ApplicationController
  before_action :redirect_if_saml, except: :destroy
  before_action :reset_session_keys
  skip_authorize_resource
  skip_authorization_check
  skip_before_action :authenticate

  layout 'login'

  def new
  end

  def create
    if APP_CONFIG['auth_method'] == 'stub' # Stubbed authentication for dev
      stub_auth

    elsif APP_CONFIG['auth_method'] == 'ldap'
      username = params[:username]
      begin
        @ldap = Ldap.new

        ldap_entry = @ldap.authenticate(username, params[:password])

        if !ldap_entry
          @error_message = 'Fel användarnamn eller lösenord. Vänligen försök igen.'
          logger.info "[LDAP_AUTH] #{username} from #{client_ip} failed to log in"
          render 'new'

        else
          # Get LDAP app group for user
          role = @ldap.belongs_to_group(ldap_entry['cn'].first)

          if !role.present?
            logger.info "[LDAP_AUTH] #{username} from #{client_ip} failed to log in: doesn't belong to a group."
            @error_message = 'Du saknar behörighet till systemet'
            render 'new'
          else
            user = @ldap.update_user_profile(username, role, client_ip)
            if user
              session[:user_id] = user.id
              logger.info "[LDAP_AUTH] #{user.username} logged in from #{client_ip}"
              redirect_after_login
            else
              @error_message = 'Kunde inte spara användarinformationen'
              render 'new'
            end
          end
        end
      rescue => e
        @error_message = 'Inloggningen fungerade inte.'
        logger.error "[LDAP_AUTH] Login failed. #{e.message}"
        logger.error e
        render 'new'
      end
    end
  end

  def destroy
    reset_session_keys

    if APP_CONFIG['auth_method'] == 'saml'
      redirect_to Rails.application.secrets.saml[:idp_slo_target_url]
    else
      redirect_to root_path, notice: 'Du är utloggad från MEKS'
    end
  end

  private

  def redirect_if_saml
    redirect_to saml_sso_path if APP_CONFIG['auth_method'] == 'saml'
  end

  # In dev env if the LDAP is not available
  # User needs to exist in the db first
  def stub_auth
    if !Rails.application.config.consider_all_requests_local
      @error_message = 'Stubbed authentication only available in local environment'
      render 'new'
    else
      user = User.where(username: params[:username].strip.downcase).first
      if user
        session[:user_id] = user.id
        update_session
        logger.debug { "Stubbed authenticated user #{current_user.id}" }
        redirect_after_login
      else
        @error_message = 'Användarnamnet finns inte'
        render 'new'
      end
    end
  end
end
