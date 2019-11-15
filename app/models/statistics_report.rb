class StatisticsReport

  attr_reader :start_date
  attr_reader :end_date
  attr_accessor :auctions, :auctions_without_offers, :auctions_with_offers

  def initialize(start_date:, end_date:)
    @start_date = start_date
    @end_date = end_date
    @auctions_per_day = {}
  end

  def gather_data
    count_auctions
  end

  def count_auctions
    (start_date..end_date).each do |date|
      auctions = Auction.active_by_date(date)

      @auctions[date] = auctions.count
      @auctions_with_offers[date] = auctions.with_offers.count
      @auctions_without_offers[date] = auctions.without_offers.count
    end
  end


end
