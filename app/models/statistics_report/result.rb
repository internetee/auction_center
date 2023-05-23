class StatisticsReport
  class Result < ApplicationRecord
    include DbView
    self.table_name = 'statistics_report_results'
  end
end
