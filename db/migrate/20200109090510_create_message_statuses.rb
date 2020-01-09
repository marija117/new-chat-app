class CreateMessageStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :message_statuses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :message, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
