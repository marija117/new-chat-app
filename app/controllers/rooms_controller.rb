class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_entities
  before_action :cannot_update, only: :edit
  before_action :is_member, only: :show

  def index
    @rooms.each do |room| 
      room[:new_messages] = room.unreaded_messages(current_user.id)
    end

    respond_to do |format|
      format.json { render json: { rooms: @rooms } }
      format.html
    end
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
    @messages = @room.messages.includes(:user).order(:created_at).as_json(only: [:message, :user_id, :created_at, :updated_at, :id])
    RoomMember.where(user_id: current_user.id, room_id: @room.id).update(last_read: Time.now)

    respond_to do |format|
      format.json { render json: { messages: @messages, room: @room } }
      format.html
    end
  end

  def load_old_messages    
    @previous_archive = MessageArchive.where(room_id: @room.id).where("from_date < ?", DateTime.parse(params[:previous_archive])).where("old_messages !=  ?", "[]").last

    render json: { messages: @previous_archive, current_user_id: current_user.id}
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
  end

  def room_parameters
    params.require(:room).permit(:name)
  end

  def cannot_update
    if current_user != Room.find(params[:id]).user
      redirect_to rooms_path
    end
  end

  def is_member
    if ! @room.users.include?(current_user)
      redirect_to rooms_path
    end
  end
end
