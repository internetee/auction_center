class StatisticsReport
  class Invoice < ApplicationRecord
    include Concerns::DBView
    self.table_name = 'statistics_report_invoices'
  end
end
