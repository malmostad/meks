class ApplicationController < ActionController::Base
  before_action :authenticate
  before_action :log_user_on_request
  before_action { add_body_class("#{controller_name} #{action_name}") }
  before_action :init_body_class

  authorize_resource
  check_authorization

  protect_from_forgery with: :exception

  SESSION_TIME = APP_CONFIG['session_time']

  def log_user_on_request
    logger.info "[REFERRER]       #{request.referrer}"
    logger.info "[USER_ID]        #{session[:user_id]}"
    logger.info "[EXPIRES_AT]     #{session[:expires_at]}"
    logger.info "[REQUESTED_BY]   #{current_user.present? ? current_user.username : 'Not authenticated'}"
    logger.info "[REQUESTED_FROM] #{client_ip}"
  end

  def current_user
    begin
      @current_user ||= User.find(session[:user_id])
    rescue
      false
    end
  end
  helper_method :current_user

  def default_legal_code
    LegalCode.where(pre_selected: true).first.try(:id)
  end

  def authenticate
    logger.info "[AUTHENTICATE]"
    if !current_user || session_expired?
      logger.info "[USER_ID]        #{session[:user_id]}"
      logger.info "[EXPIRES_AT]     #{session[:expires_at]}"
      logger.info "[NOT CURRENT_USER]  #{!current_user.class}"
      logger.info "[SESSION_EXPIRED]  #{session_expired?.class}"

      reset_session_keys
      unless request.xhr?
        # Remember where the user was about to go
        session[:requested_url] = request.fullpath
      end
      flash.now[:warning] = "Du har varit inaktiv i #{SESSION_TIME} minuter och har loggats ut från MEKS" if session_expired?
      redirect_to login_path
    else
      update_session
    end
  end

  def reset_session_keys
    reset_session
    session[:user_id] = nil
    session[:expires_at] = nil
  end

  def session_expired?
    return true if session[:expires_at].nil? || session[:expires_at] < Time.now
  end

  def update_session
    logger.info "[UPDATE_SESSION]"
    session[:expires_at] = Time.now + SESSION_TIME.minutes
  end

  def redirect_after_login
    if session[:requested_url]
      requested_url = session[:requested_url]
      session[:requested_url] = nil
      redirect_to requested_url
    else
      redirect_to root_path
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    logger.warn "#{exception.message}"
    redirect_to root_path, alert: 'Din roll saknar behörighet för detta'
  end

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    logger.debug { "#{exception.message}" }
    logger.warn "ActionController::InvalidAuthenticityToken (maybe session expired) for the user from #{client_ip}"
    redirect_to logout_path, notice: 'Du är utloggad från MEKS'
  end

  rescue_from ActiveRecord::RecordNotFound,
              ActionController::RoutingError,
              ActionController::UnknownController,
              ActionController::MethodNotAllowed do |exception|

    logger.warn "#{exception.message}"
    logger.warn "Not found: #{request.fullpath}"
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: 404 }
      format.all  { render nothing: true, status: 404 }
    end
  end

  def init_body_class
    add_body_class(Rails.env) unless Rails.env.production?
    add_body_class('user') if current_user.present?
  end

  # Adds classnames to the body tag
  def add_body_class(name)
    @body_classes ||= ''
    @body_classes << "#{name} "
  end

  def reset_body_classes
    @body_classes = nil
    init_body_class
  end

  def client_ip
    request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
  end
end
