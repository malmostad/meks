class ApplicationController < ActionController::Base
  before_action :authenticate, :log_username_at_request
  authorize_resource
  check_authorization

  protect_from_forgery with: :exception

  before_action { add_body_class("#{controller_name} #{action_name}") }
  before_action :init_body_class

  def log_username_at_request
    username = current_user.present? ? current_user.username : 'Not authenticated'
    logger.info { "USERNAME: #{username}" }
    logger.info { "IP:       #{request.remote_ip}" }
  end

  def current_user
    begin
      @current_user ||= User.find(session[:user_id])
    rescue
      false
    end
  end
  helper_method :current_user

  def authenticate
    if !current_user
      if !request.xhr? # TODO: handle this separately
        # Remember where the user was about to go
        session[:requested_url] = request.fullpath
      end
      redirect_to login_path
    end
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
    redirect_to root_path, alert: 'Din roll saknar behörighet för detta'
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
end
