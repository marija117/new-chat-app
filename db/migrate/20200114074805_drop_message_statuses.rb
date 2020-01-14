class DropMessageStatuses < ActiveRecord::Migration[6.0]
  def change
    drop_table :message_statuses
  end
end
