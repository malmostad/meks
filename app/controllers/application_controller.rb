class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action { add_body_class("#{controller_name} #{action_name}") }
  before_action :authenticate

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

  def init_body_class
    add_body_class(Rails.env)
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
