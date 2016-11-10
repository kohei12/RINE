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
    @unaccepted_requests = unaccepted_requests
    @waiting_requests = waiting_requests
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

  def authenticate
    unless current_user.present?
      redirect_to log_in_path
    else
      true
    end
  end

  # requests sent to current_user
  # returns array of ids
  def unaccepted_requests
    requests = Friendship.where(friend_id: current_user.id)
    return unless requests
    requests.map do |request|
      if request.status == "pending"
        request
      else
        nil
      end
    end
  end

  # requests sent by current_user
  # returns array of ids
  def waiting_requests
    requests = Friendship.where(user_id: current_user.id)
    return unless requests
    requests.map do |request|
      if request.status == "pending"
        request
      else
        nil
      end
    end
  end

  # FIXME
  def search(email)
    if email
      User.find_by(email: email)
    end
  end
end
