class DailyViewRefreshJob < ApplicationJob
  def perform
    [StatisticsReport::Auction,
     StatisticsReport::Invoice,
     StatisticsReport::Result].each(&:refresh)
  end

  def self.needs_to_run?
    true
  end
end
