class SessionsController < ApplicationController
  skip_authorize_resource
  skip_authorization_check
  skip_before_action :authenticate

  layout 'login'

  def new
  end

  def create
    username = params[:username].strip.downcase

    if APP_CONFIG['stub_auth'] # Stubbed authentication for dev
      stub_auth(username)

    else # Authenticate with LDAP
      @ldap = LdapAuth.new

      ldap_entry = @ldap.authenticate(username, params[:password])

      if !ldap_entry
        @login_failed = 'Fel användarnamn eller lösenord. Vänligen försök igen.'
        logger.info "AUTH: #{params[:username]} from #{request.remote_ip}failed to log in"
        render 'new'

      else
        # Find or create user
        user = User.where(username: username).first_or_initialize

        # Get LDAP app group for user
        role = @ldap.belongs_to_group(ldap_entry['cn'].first)

        if !role.present?
          logger.info "AUTH: #{params[:username]} from #{request.remote_ip} failed to log in: doesn't belong to a group"
          @login_failed = 'Du saknar behörighet till systemet'
          render 'new'
        else
          # Get user attributes and role assignments from ldap
          user.username = ldap_entry['cn'].first
          user.name     = ldap_entry['displayname'].first || ldap_entry['cn'].first
          user.email    = ldap_entry['mail'].first || "#{user.username}@malmo.se"
          user.role     = role
          user.last_login = Time.now
          user.ip = request.remote_ip
          user.save
          session[:user_id] = user.id
          logger.info "AUTH: #{params[:username]} logged in from #{request.remote_ip}"
          redirect_after_login
        end
      end
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'Nu är du utloggad från MEKS'
  end

  private

  # In dev env if the LDAP is not available
  # User needs to exist
  def stub_auth(username)
    user = User.where(username: username).first
    if user
      session[:user_id] = user.id
      logger.debug { "Stubbed authenticated user #{current_user.id}" }
      redirect_after_login
    else
      @login_failed = "Användarnamnet finns inte"
      render "new"
    end
  end
end
