class AddDailySummaryToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :daily_summary, :boolean, null: false, default: false
  end
end
