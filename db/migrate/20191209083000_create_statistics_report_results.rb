class CreateStatisticsReportResults < ActiveRecord::Migration[6.0]
  def change
    create_view :statistics_report_results, materialized: true
    add_index :statistics_report_results, :id, unique: true
  end
end
