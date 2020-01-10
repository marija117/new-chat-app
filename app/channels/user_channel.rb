class UserChannel < ApplicationCable::Channel
  def subscribed
    user = current_user
    stream_for user
  end

  def unsubscribed
    # if @current_user.present? 
    #     ActionCable.server.broadcast('appearance',{data: @current_user.disappear,action: 'SubscribedList'})
    # end
  end
end
