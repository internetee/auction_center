require 'test_helper'

class AuctionDataTest < ActiveSupport::TestCase
  def setup
    super
    @start_date = Auction.first.starts_at.to_date
    @end_date = Auction.last.ends_at.to_date
    [Auction, Result, Invoice].each do |klass|
      klass.reindex
    end
    Searchkick.enable_callbacks
  end

  def teardown
    Searchkick.disable_callbacks
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
      report.gather_data
    end
  end
end
