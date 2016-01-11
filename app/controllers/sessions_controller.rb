class SessionsController < ApplicationController
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
        render 'new'

      else
        # Find or create user
        user = User.where(username: username).first_or_initialize

        # Get user attributes and role assignments from ldap
        user.merge @ldap.user_attributes(ldap_entry)

        if !user.role
          @login_failed = 'Du saknar behörighet till systemet'
          render 'new'
        else
          user.last_login = Time.now
          user.save
          session[:user_id] = user.id
          redirect_after_login
        end
      end
    end
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "Nu är du utloggad från MEKS"
  end

  private

  # In dev env if the LDAP is not available
  # User needs to exist
  def stub_auth(username)
    if !Rails.application.config.consider_all_requests_local
      @login_failed = "Stubbed authentication only available in local environment"
      render 'new'
    else
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
end
