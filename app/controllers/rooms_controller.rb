class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_entities

  def index
    @rooms = Room.all
  end

  def new
    @room = Room.new
    @users = User.all
  end

  def create
    @room = Room.new room_parameters
    @room.owner_id = current_user.id
    @room.user_ids = params[:user_ids]

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
  end

  private

  def load_entities
    @rooms = Room.all
    @room = Room.find(params[:id]) if params[:id]
  end

  def room_parameters
    params.require(:room).permit(:name)
  end
end
