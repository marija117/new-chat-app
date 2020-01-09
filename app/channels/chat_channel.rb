class ChatChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find(params[:room])
    stream_for room
  end

  def unsubscribed
  end
end
