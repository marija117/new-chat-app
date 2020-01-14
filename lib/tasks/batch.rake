namespace :batch do
  desc "TODO"
  task archive_message: :environment do
    @rooms = Room.all
    @rooms.each do |room|
      @last_read = RoomMember.where(room_id: room.id).pluck(:last_read)
      @readed_messages = room.messages.where("created_at <  ?", @last_read)
      MessageArchive.first_or_create({
        room_id: room.id,
        from_date: Time.now - 1.day,
        to_date: Time.now,
        old_messages: { 
          user_id: 1,
          message: 'hsdiefhise'
        }
      })
    end
  end

end
