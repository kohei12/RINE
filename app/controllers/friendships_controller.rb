class FriendshipsController < ApplicationController
  before_action :authenticate

  def create
    friend = User.find(params[:friend_id])
    if @request = Friendship.request(current_user, friend)
      flash[:notice] = 'success!'
    else
      flash[:notice] = 'failure!'
    end
    redirect_to user_path(current_user.id)
  end

  def show
  end

  def update
    requested_user = User.find(params[:requested_user_id])
    @request = Friendship.find_by(requested_user: requested_user, friend: current_user)
    if @request.accept(current_user, requested_user)
      flash[:notice] = '友達になりました。'
    else
      flash[:notice] = '承認に失敗しました'
    end
    redirect_to user_path(current_user.id)
  end

  def destroy
  end

  def reject
  end
end
