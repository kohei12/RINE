# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_#{params[:room]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    binding.pry
    Message.create!(text: data['message'])
  end

  def receive(data)
    RoomChannel.broadcast_to("room_#{params[:room]}", data)
  end
end
