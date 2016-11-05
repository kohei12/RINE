class SessionsController < ApplicationController
  def new
    redirect_to user if current_user
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      if params[:remember_me]
        cookies.permanent[:auth_tokne] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      redirect_to user
    else
      # flash
      render "new"
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_url
  end

  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
end
