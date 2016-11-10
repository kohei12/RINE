class SessionsController < ApplicationController
  def new
    redirect_to current_user if current_user
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      log_in(user)
      redirect_to user
    else
      # flash
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to log_in_path
  end
end
