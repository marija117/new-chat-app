class RoomMember < ApplicationRecord
  belongs_to :room
  belongs_to :user

  attribute :new_messages, :integer, default: 0
end
