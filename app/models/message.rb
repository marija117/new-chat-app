class Message < ApplicationRecord
    belongs_to :user
    belongs_to :room
    has_many :message_statuses
    has_many :users, through: :message_statuses

end
