class AddDailySummaryToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :daily_summary, :boolean, default: false
  end
end
