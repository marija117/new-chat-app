class DropRoomsUsers < ActiveRecord::Migration[6.0]
  def change
    drop_table :rooms_users
  end
end
