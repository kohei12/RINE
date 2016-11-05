module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    return unless current_user
    current_user.nil?
  end

  def log_out
    session.delete(@current_user)
    @current_user = nil
  end
end
