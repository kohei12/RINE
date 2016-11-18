class RoomsController < ApplicationController
  before_action :check_member, only: [:show]
  before_action :authenticate
  
  def index
    @user = current_user
    @rooms = accepted_friendships
  end

  def show
    @room = Room.find(params[:id])
    @user = current_user
    @friend = friend(@room)
    @messages = @room.messages
  end

  private

  def friend(room)
    friendship = room.friendship
    friend = friendship.requested_user == current_user ? friendship.friend : friendship.requested_user
    friend
  end

  def check_member
    friendship = Room.find(params[:id]).friendship
    unless current_user.id == friendship.user_id || current_user.id == friendship.friend_id
      redirect_to current_user
    else
      true
    end
  end

  def my_friendships
    Friendship.where("user_id = ? OR friend_id = ?", current_user.id, current_user.id)
  end

  def specific_friendship(friend)
    my_friendships.find_by("user_id = ? OR friend_id = ?", friend.id, friend.id)
  end

  def accepted_friendships
    my_friendships.where(status: "accepted")
  end
end
