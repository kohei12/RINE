class RoomsController < ApplicationController
  before_action :check_member, only: [:show]
  before_action :authenticate
  
  def index
    @user = current_user
    @rooms = current_user.accepted_friendships
  end

  def show
    @user = current_user
    @friend = friend
    @room = room
    @messages = @room.messages
  end

  private

  def room
    Room.find(params[:id])
  end

  def friend
    friendship = room.friendship
    friend = friendship.requested_user == current_user ? friendship.friend : friendship.requested_user
    friend
  end

  def check_member
    friendship = room.friendship
    unless current_user.id == friendship.user_id || current_user.id == friendship.friend_id
      redirect_to current_user
    else
      true
    end
  end
end
