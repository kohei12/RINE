module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
  end

  def logged_in?
    return unless current_user
    current_user.nil?
  end

  def log_out
    session[:user_id] = nil
    @current_user = nil
  end

  def authenticate
    unless current_user.present?
      redirect_to log_in_path
    else
      true
    end
  end
end
