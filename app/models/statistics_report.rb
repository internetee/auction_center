class StatisticsReport
  attr_reader :start_date
  attr_reader :end_date
  ATTRS = %i[auctions auctions_without_offers auctions_with_offers average_offers_per_auction
             unregistered_domains unpaid_invoice_percentage unregistered_domains_count_by_end
             registered_domains_count_by_end total_invoices_count unpaid_invoices_count
             paid_invoices_count].freeze

  attr_accessor(*ATTRS)

  def initialize(start_date:, end_date:)
    @start_date = start_date
    @end_date = end_date
    @auctions_per_day = {}
    ATTRS.each { |attr| send("#{attr}=", {}) }
  end

  def gather_data
    auctions_count
    average_bids
    paid_unregistered_domains
    count_invoices
    domains_by_end
  end

  def auctions_count
    (start_date..end_date).each do |date|
      auctions = Auction.where('starts_at <= ? AND ends_at >= ?', date, date)
      @auctions[date] = auctions.count
      @auctions_with_offers[date] = auctions.with_offers.count
      @auctions_without_offers[date] = auctions.without_offers.count
    end
  end

  def average_bids
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

  def paid_unregistered_domains
    (start_date..end_date).each do |date|
      results = unregistered_domains_by_date(date)
      @unregistered_domains[date] = results.count
    end
  end

  def count_invoices
    (start_date..end_date).each do |date|
      total_invoices, unpaid_invoices = calculate_invoices(date)
      unpaid_invoice_percentage[date] = if total_invoices.count.positive?
                                          unpaid_invoices.count * 100.0 / total_invoices.count
                                        else
                                          0
                                        end
    end
  end

  def calculate_invoices(date)
    total_invoices = Invoice.where(issue_date: date)
    unpaid_invoices = Invoice.where(issue_date: date).where(status: 'issued')
    paid_invoices = Invoice.where(issue_date: date).where(status: 'paid')
    assign_raw_data(date: date, total_invoices: total_invoices,
                    unpaid_invoices: unpaid_invoices, paid_invoices: paid_invoices)
    [total_invoices, unpaid_invoices]
  end

  def assign_raw_data(date:, total_invoices:, unpaid_invoices:, paid_invoices:)
    total_invoices_count[date] = total_invoices.count
    unpaid_invoices_count[date] = unpaid_invoices.count
    paid_invoices_count[date] = paid_invoices.count
  end

  def domains_by_end
    (start_date..end_date).each do |date|
      unregistered_domains_count_by_end[date] = unregistered_domains_by_end(date).count
      registered_domains_count_by_end[date] = registered_domains_by_end(date).count
    end
  end

  def unregistered_domains_by_date(date)
    Result.unregistered.by_auction_created_date(date)
  end

  def unregistered_domains_by_end(date)
    Result.unregistered.by_auction_end_date(date)
  end

  def registered_domains_by_end(date)
    Result.registered.by_auction_end_date(date)
  end
end
