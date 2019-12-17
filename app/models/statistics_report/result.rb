class StatisticsReport
  class Result < ApplicationRecord
    include Concerns::DBView
    self.table_name = 'statistics_report_results'
  end
end
