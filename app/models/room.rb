class Room < ApplicationRecord
  belongs_to :user, foreign_key: :owner_id
  has_many :messages, dependent: :destroy
  has_many :room_members, dependent: :destroy
  has_many :users, :through => :room_members
  has_many :message_archives, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { minimum: 5 }

  attribute :new_messages, :integer, default: 0

  def unreaded_messages(user)
    @last_read = RoomMember.where(user_id: user, room_id: self.id).pluck(:last_read)
    @last_read = @last_read[0]

    return self.messages.where("created_at >  ?", @last_read).count
  end

end
