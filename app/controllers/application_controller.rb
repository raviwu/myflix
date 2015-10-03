class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logged_in?, :current_user, :require_user, :access_deny

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out(user)
    session[:user_id] = nil
    @current_user = nil
  end

  def current_user
    @current_user ||= (User.find(session[:user_id]) if session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def require_user
    access_deny unless logged_in?
  end

  def access_deny
    flash[:danger] = "Sorry, cannot do that."
    redirect_to root_path
  end
end
