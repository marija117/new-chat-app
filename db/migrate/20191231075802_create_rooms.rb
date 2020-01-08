class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.text :name,  null: false
      t.references :owner, references: :users, foreign_key: { to_table: :users }
      t.timestamps
    end
    add_index :rooms, :name,                unique: true
  end
end
