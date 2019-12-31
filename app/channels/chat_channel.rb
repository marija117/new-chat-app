class ChatChannel < ApplicationCable::Channel
  def subscribed
    # here need to receive room 
    room = Room.find(params[:room])
    stream_for room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
