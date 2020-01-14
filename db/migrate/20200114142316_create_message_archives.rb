class CreateMessageArchives < ActiveRecord::Migration[6.0]
  def change
    create_table :message_archives do |t|
      t.references :room, null: false, foreign_key: true
      t.jsonb :old_messages
      t.datetime :from_date
      t.datetime :to_date

      t.timestamps
    end
  end
end
