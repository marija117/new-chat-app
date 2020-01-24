class MessageController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    logger.debug "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    logger.debug params[:message]
    logger.debug params[:message_id]

    @message = Message.find_or_initialize_by(id: params[:message_id])

    @message.message = params[:message]
    @message.user_id = current_user.id
    @message.room_id = params[:room_id]
    @room = Room.find(params[:room_id])
    @members = @room.users.where.not(id: current_user.id)
    @roomMember = RoomMember.where(user_id: current_user.id, room_id: @room.id).first_or_create
    @roomMember.update(last_read: Time.now)

    if @message.save
      @members.each do |user|
        RoomMember.first_or_create(user_id: user.id, room_id: @room.id)
        UserChannel.broadcast_to user,
          new_messages: @room.unreaded_messages(user),
          room_id: @room.id
      end
      ChatChannel.broadcast_to @room, @message
    else
      logger.debug "Errors: #{@message.errors.full_messages}"
    end
  end
end
