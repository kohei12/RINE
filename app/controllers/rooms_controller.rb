class RoomsController < ApplicationController
  before_action :authenticate
  
  def index
    @friendships = current_user.accepted_friendships
  end

  def show
   # @user = current_user
   # @friend = friend
   # @room = room
    @messages = Message.all
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
end
