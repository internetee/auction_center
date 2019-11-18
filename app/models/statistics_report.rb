class StatisticsReport
  attr_reader :start_date
  attr_reader :end_date
  ATTRS = %i[auctions
             auctions_without_offers
             auctions_with_offers
             average_offers_per_auction
             unregistered_domains].freeze

  attr_accessor(*ATTRS)

  def initialize(start_date:, end_date:)
    @start_date = start_date
    @end_date = end_date
    @auctions_per_day = {}
    ATTRS.each { |attr| send("#{attr}=", {}) }
  end

  def gather_data
    count_auctions
    count_average_bids
    count_paid_unregistered_domains
  end

  def count_auctions
    (start_date..end_date).each do |date|
      auctions = Auction.where('starts_at <= ? AND ends_at >= ?', date, date)
      @auctions[date] = auctions.count
      @auctions_with_offers[date] = auctions.with_offers.count
      @auctions_without_offers[date] = auctions.without_offers.count
    end
  end

  def count_average_bids
    (start_date..end_date).each do |date|
      auctions = Auction.where('starts_at <= ? AND ends_at >= ?', date, date).with_offers
      @average_offers_per_auction[date] = count_total_offers(auctions)
    end
  end

  def count_total_offers(auctions)
    if auctions.present?
      total_offers = auctions.map { |auction| auction.offers.count }.sum
      total_offers / (auctions.count * 1.0)
    else
      0
    end
  end

  def count_paid_unregistered_domains
    (start_date..end_date).each do |date|
      results = Result.where(status: 'domain_not_registered')
                      .joins(:auction)
                      .where(auctions: { created_at: date })
      @unregistered_domains[date] = results.count
    end
  end
end
