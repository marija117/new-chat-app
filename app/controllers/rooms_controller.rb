class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_entities
  before_action :cannot_update, only: :edit

  def index
    # @rooms.each do |room|
    #   @unreaded_messages = @room.message_statuses.where(read: false).where(user_id: current_user.id).count + 1
    # end
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new room_parameters
    @room.owner_id = current_user.id
    @room.user_ids = params[:user_ids].push(current_user.id)

    if @room.save
      flash[:success] = "Room #{@room.name} was created successfully"
      redirect_to rooms_path
    else
      render :new
    end
  end

  def show
    @room_message = Message.new room_id: @room.id
    @room_messages = @room.messages.includes(:user)
    @room.message_statuses.where(user_id: current_user.id).update(read: true)
  end

  def edit
    @users = User.where.not(id: current_user.id)
  end

  def update
    @room.user_ids = params[:user_ids].push(current_user.id)

    if @room.update(room_parameters)
      flash[:success] = "Room #{@room.name} was updated successfully"
      redirect_to rooms_path
    else
      render :edit
    end
  end

  def destroy
    @room.destroy
 
    redirect_to rooms_path
  end

  private

  def load_entities
    @rooms = current_user.rooms    
    @room = Room.find(params[:id]) if params[:id]
    @users = User.where.not(id: current_user.id)
    @unreaded_messages = @room.message_statuses.where(read: false).where(user_id: current_user.id).count+1
  end

  def room_parameters
    params.require(:room).permit(:name)
  end

  def cannot_update
    if current_user != Room.find(params[:id]).user
      redirect_to rooms_path
    end
  end
end
