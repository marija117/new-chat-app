namespace :batch do
  desc "Archive readed messages"
  task archive_message: :environment do
    @rooms = Room.all
    @rooms.each do |room|
      @last_read = RoomMember.where(room_id: room.id).order(last_read: :desc).limit(1).pluck(:last_read)[0]
      @readed_messages = room.messages.where("created_at <  ?", @last_read)

      @old_messages = []
      @readed_messages.each do |msg|
        @old_messages << {
          user_id: msg.user_id,
          id: msg.id,
          message: msg.message,
          created_at: msg.created_at
        }
      end
      
      @message_archive = MessageArchive.create(
        room_id: room.id,
        from_date: Time.now - 1.day,
        to_date: Time.now,
        old_messages: @old_messages
      )

      @readed_messages.delete_all
    end
  end

end
