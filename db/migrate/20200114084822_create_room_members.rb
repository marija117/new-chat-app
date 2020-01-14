class CreateRoomMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :room_members do |t|
      t.references :room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :last_read

      t.timestamps
    end
  end
end
