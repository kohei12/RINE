class UsersController < ApplicationController
  before_action :authenticate, only: [:show, :destroy]

  def new
    redirect_to current_user if current_user
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @found_user = search(params[:search])
    @unaccepted_requests = current_user.unaccepted_requests
    @waiting_requests = current_user.waiting_requests
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      session[:user_id] = nil
      redirect_to sign_up_path
    else
      redirect_to @user
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

  # FIXME
  def search(email)
    if email
      User.find_by(email: email)
    end
  end
end
