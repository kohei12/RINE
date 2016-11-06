class MessagesController < ApplicationController
  def create
    binding.pry
    @message = Message.new(message_params)
    @message.room = 
    @message.user = 
    if @message.save
      redirect_to messages_path
    else
      redirect_to messages_path
    end
  end

  private

  def message_params
    params.require(:message).permit(:text)
  end
end
