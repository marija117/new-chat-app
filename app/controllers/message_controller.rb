class MessageController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  
  def index
    @messages = Message.all
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id
    @message.save

    ActionCable.server.broadcast("chat_channel", @message)

    redirect_to messages_path
  end
   
  private
    def message_params
      params.require(:message).permit(:message)
    end
end
