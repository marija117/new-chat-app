class MessageController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id
    @room = Room.find(message_params[:room_id])

    if @message.save
      ChatChannel.broadcast_to @room, @message
    else
      logger.debug "Errors: #{@message.errors.full_messages}"
    end
  end
   
  private
     def message_params
      params.require(:message).permit(:message, :room_id)
    end
end
