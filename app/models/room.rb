class Room < ApplicationRecord
    belongs_to :user, foreign_key: :owner_id
    has_many :messages
    has_and_belongs_to_many :users

    validates :name, presence: true, uniqueness: true, length: { minimum: 5 }
end
