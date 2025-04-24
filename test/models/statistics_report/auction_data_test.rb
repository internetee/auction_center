require 'test_helper'

class AuctionDataTest < ActiveSupport::TestCase

  def setup
    super
    # @start_date = Auction.first.starts_at.to_date
    # @end_date = Auction.last.ends_at.to_date
    @start_date = Time.zone.now - 2.days
    @end_date = Time.zone.now + 2.days
    [StatisticsReport::Auction,
     StatisticsReport::Result,
     StatisticsReport::Invoice].each { |klass| klass.refresh }
  end

  def test_gather_data_calls_required_methods
    mock = Minitest::Mock.new

    StatisticsReport::AuctionData.stub(:new,
                                       mock,
                                       [start_date: @start_date, end_date: @end_date]) do
      mock.expect(:gather_data, {})
      mock.expect(:auctions_count, [])
      mock.expect(:daily_offers, [])
      mock.expect(:average_offers, [])

      report = StatisticsReport::AuctionData.new(start_date: @start_date, end_date: @end_date)
      result = report.gather_data
      
      assert_equal({}, result)
      assert_mock(mock)
    end
  end
end
