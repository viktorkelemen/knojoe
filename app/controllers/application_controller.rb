class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_timezone

  protected

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def signed_in?
    !!current_user
  end
  helper_method :current_user, :signed_in?

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.nil? ? user : user.id
  end

  def require_login
    unless signed_in?
      session[:return_to] = request.path
      redirect_to login_path, alert: 'You must be logged in to access this section.'
    end
  end

  # Google Analytics event logging
  def log_event(category, action, label = nil, value = nil)
    session[:events] ||= Array.new
    session[:events] << { :category => category, :action => action, :label => label, :value => value }
  end

  private

  def set_timezone
    Time.zone = cookies["time_zone"]
  end
end
