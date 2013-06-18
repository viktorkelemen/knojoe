class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Exception, :with => :render_500 if Rails.env.production?
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  before_filter :set_user_id
  def set_user_id
    session[:user_id] = User.first.id
  end

  protected

  def render_404
    render :template => 'errors/404', :layout => 'fullscreen_errors', :status => 404
  end

  def render_500
    render :template => 'errors/500', :layout => 'fullscreen_errors', :status => 500
  end

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
end
