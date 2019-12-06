require 'test_helper'

class StatisticsReportTest < ActiveSupport::TestCase

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

    StatisticsReport.stub(:new, mock, [start_date: @start_date, end_date: @end_date]) do
      mock.expect(:gather_data, {})

      summary_report = StatisticsReport.new(start_date: @start_date, end_date: @end_date)
      summary_report.gather_data
    end
  end

  def test_count_auctions
    report = StatisticsReport.new(start_date: @start_date, end_date: @end_date)
    report.gather_data
    asserted_count = Auction.search(where: { starts_at: { lte: @end_date },
                                             ends_at: { gte: @end_date } })
                            .count
    assert(report.auctions.is_a?(Hash))
    assert_equal(report.auctions[@end_date], asserted_count)
  end
end
