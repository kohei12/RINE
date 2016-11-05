class UsersController < ApplicationController
  # before_action :authenticate, only: [:show]
  def new
    redirect_to user if current_user
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @found_user = search(params[:search])
    @unaccepted_request_ids = unaccepted_request_ids(@user)
    @waiting_request_ids = waiting_request_ids(@user)
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

  def authenticate
    unless current_user
      redirect_to log_in_path
    else
      true
    end
  end

  # requests sent to current_user
  # returns array of ids
  def unaccepted_request_ids(user)
    ids = Friendship.where(friend: user).map(&:id)
    return unless ids
    ids.map do |id|
      request = Friendship.find(id)
      request.id if request.status == 'pending'
    end
  end

  # requests sent by current_user
  # returns array of ids
  def waiting_request_ids(user)
    ids = Friendship.where(user: user).map(&:id)
    return unless ids
    ids.map do |id|
      request = Friendship.find(id)
      request.id if request.status == 'pending'
    end
  end

  # FIXME
  def search(email)
    if email
      User.find_by(email: email)
    end
  end

  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
end
