class CreateStatisticsReportAuctions < ActiveRecord::Migration[6.0]
  def change
    create_view :statistics_report_auctions, materialized: true
    add_index :statistics_report_auctions, :id, unique: true
  end
end
