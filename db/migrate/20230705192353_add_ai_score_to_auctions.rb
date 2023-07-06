class AddAiScoreToAuctions < ActiveRecord::Migration[7.0]
  def change
    add_column :auctions, :ai_score, :integer, default: 0
  end
end
