class MessageController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id
    @room = Room.find(message_params[:room_id])

    if @message.save
      @room.users.each do |user|
        MessageStatus.create(user_id: user.id, message_id: @message.id, room_id: @room.id)
      end
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
