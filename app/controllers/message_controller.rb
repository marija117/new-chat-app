class MessageController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id
    @room = Room.find(message_params[:room_id])
    # @room.users.each do |user|
    #   @unreaded_messages = @room.message_statuses.where(user_id: user.id, read: false).count
    # end
    @members = @room.users.where.not(id: current_user.id)

    if @message.save
      @members.each do |user|
        @unreaded_messages = @room.message_statuses.where(read: false).where(user_id: user.id).count + 1
        logger.debug @unreaded_messages
        MessageStatus.create(user_id: user.id, message_id: @message.id, room_id: @room.id)
        UserChannel.broadcast_to user, 
          new_messages:  @unreaded_messages
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
