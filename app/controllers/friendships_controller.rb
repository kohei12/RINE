class FriendshipsController < ApplicationController
 def create
   binding.pry
    current_user = User.find(params[:user_id])
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
    current_user = User.find(params[:id])
    @request = current_user.friendships.find_by(friend: friend)
    if @request.accept(current_user, friend)
      flash[:notice] = '友達になりました。'
    else
      flash[:notice] = '承認に失敗しました'
    end
    redirect_to user_path(current_user.id)
  end

  def index
    current_user = User.find(params[:id])
    @friendships = current_user.friendships.all
  end

  def destroy
  end

  def reject
  end

  private

  def friend
    @friend ||= User.find(params[:friend_id])
  end
end
