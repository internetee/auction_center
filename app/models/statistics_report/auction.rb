class StatisticsReport
  class Auction < ApplicationRecord
    include DbView
    self.table_name = 'statistics_report_auctions'
  end
end
