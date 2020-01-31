class RoomChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find(params[:room])
    reject unless room.users.pluck(:user_id).include?(current_user.id)
    stream_for room
  end

  def unsubscribed
  end
end
