class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_entities
  before_action :cannot_update, only: :edit
  before_action :is_member, only: :show

  def index
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
    @message_archive = MessageArchive.where(room_id: @room.id).where("old_messages !=  ?", "[]").last
   
    @new_messages = @room.messages.includes(:user).as_json(only: [:message, :user_id, :created_at])
    @messages = @message_archive ? @message_archive.old_messages.concat(@new_messages) : @new_messages

    RoomMember.where(user_id: current_user.id, room_id: @room.id).update(last_read: Time.now)
  end

  def load_old_messages
    @previous_archive = MessageArchive.where(room_id: @room.id).where("from_date < ?", params[:previous_archive]).where("old_messages !=  ?", "[]").last
    @from_date = @previous_archive.from_date if @previous_archive

    render json: { messages: @previous_archive, from_date: @from_date }
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
