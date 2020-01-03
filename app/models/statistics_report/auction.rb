class StatisticsReport
  class Auction < ApplicationRecord
    include Concerns::DBView
    self.table_name = 'statistics_report_auctions'
  end
end
