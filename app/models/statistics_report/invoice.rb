class StatisticsReport
  class Invoice < ApplicationRecord
    include DbView
    self.table_name = 'statistics_report_invoices'
  end
end
