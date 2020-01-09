class UserChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find(params[:room])
    stream_for room
  end

  def unsubscribed
    # if @current_user.present? 
    #     ActionCable.server.broadcast('appearance',{data: @current_user.disappear,action: 'SubscribedList'})
    # end
end
