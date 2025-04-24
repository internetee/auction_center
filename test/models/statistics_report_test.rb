require 'test_helper'

class StatisticsReportTest < ActiveSupport::TestCase

  def setup
    super
    # @start_date = Auction.first.starts_at.to_date
    # @end_date = Auction.last.ends_at.to_date
    auction_one = auctions(:valid_with_offers)
    auction_two = auctions(:orphaned)
    @start_date = auction_one.starts_at.to_date
    @end_date = auction_two.ends_at.to_date
    [StatisticsReport::Auction,
     StatisticsReport::Result,
     StatisticsReport::Invoice].each { |klass| klass.refresh }
  end

  def test_gather_data_calls_required_methods
    mock = Minitest::Mock.new

    StatisticsReport.stub(:new, mock, [start_date: @start_date, end_date: @end_date]) do
      mock.expect(:gather_data, {})

      summary_report = StatisticsReport.new(start_date: @start_date, end_date: @end_date)
      result = summary_report.gather_data
      
      assert_equal({}, result)
      assert_mock(mock)
    end
  end

  def test_count_auctions
    report = StatisticsReport.new(start_date: @start_date, end_date: @end_date)
    report.gather_data
    asserted_count = StatisticsReport::Auction
                       .where('starts_at <= ? AND ends_at >= ?', @end_date, @end_date).count

    assert(report.auctions.is_a?(Hash))
    assert_equal(report.auctions[@end_date], asserted_count)
  end
end
