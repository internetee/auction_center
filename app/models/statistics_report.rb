class StatisticsReport

  attr_reader :start_date
  attr_reader :end_date
  attr_accessor :auctions_per_day

  def initialize(start_date:, end_date:)
    @start_date = start_date
    @end_date = end_date
    @auctions_per_day = {}
  end

  def gather_data
    auctions_per_day
  end

  def auctions_per_day
    (start_date..end_date).each do |date|
      auctions_count = Auction.active_by_date(date).count
      @auctions_per_day[date] = auctions_count
    end
  end

end
