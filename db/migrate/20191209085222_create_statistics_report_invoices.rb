class CreateStatisticsReportInvoices < ActiveRecord::Migration[6.0]
  def change
    create_view :statistics_report_invoices, materialized: true
    add_index :statistics_report_invoices, :id, unique: true
  end
end
