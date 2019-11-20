class StatisticsReport
  attr_reader :start_date
  attr_reader :end_date
  ATTRS = %i[auctions auctions_without_offers auctions_with_offers offers_per_day
             average_offers_per_auction unregistered_domains unpaid_invoice_percentage
             unregistered_domains_count_by_end registered_domains_count_by_end
             total_invoices_count unpaid_invoices_count paid_invoices_count users].freeze

  attr_accessor(*ATTRS)

  def initialize(start_date:, end_date:)
    @start_date = start_date
    @end_date = end_date
    ATTRS.each { |attr| send("#{attr}=", {}) }
  end

  def gather_data
    auctions_count
    paid_unregistered_domains
    # count_invoices
    # domains_by_end
  end

  def auctions_count
    report = StatisticsReport::AuctionData.new(start_date: start_date, end_date: end_date)
    report.gather_data
    @auctions = report.auctions
    @auctions_with_offers = report.auctions_with_offers
    @auctions_without_offers = report.auctions_without_offers
    @offers_per_day = report.offers_per_day
    @average_offers_per_auction = report.average_offers_per_auction
  end

  def paid_unregistered_domains
    report = StatisticsReport::UnregisteredDomainsData.new(start_date: start_date,
                                                           end_date: end_date)

    report.gather_data
    @unregistered_domains = report.unregistered_domains
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

  def unregistered_domains_by_end(date)
    Result.unregistered.by_auction_end_date(date)
  end

  def registered_domains_by_end(date)
    Result.registered.by_auction_end_date(date)
  end

  def auction_winners
    @users = User.joins(:results)
                 .group('users.given_names')
                 .count
                 .sort_by { |_key, value| value }
                 .to_h
  end
end
