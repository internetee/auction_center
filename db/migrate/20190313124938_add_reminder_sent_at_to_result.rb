class AddReminderSentAtToResult < ActiveRecord::Migration[5.2]
  def change
    add_column :results, :registration_reminder_sent_at, :datetime, null: true
  end
end
