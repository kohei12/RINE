class RoomsController < ApplicationController
  # before_action :authenticate
  
  def index
    @rooms = current_user.rooms
  end

  def show
    @message = Message.new
    @room = Room.find(params[:id])
    @messages = Message.find_by(room_id: @room)
    unless @messages.nil?
      @my_messages = @messages.where(user: current_user)
      @friend_messages = @messages.where(user: @room.friend)
    end
  end

  private

  def authenticate
    return unless current_user
  end

  def current_user
    # FIXME
    User.first
  end
end
