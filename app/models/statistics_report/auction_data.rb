class StatisticsReport
  class AuctionData
    include Concerns::SearchQueries
    attr_reader :start_date
    attr_reader :end_date
    ATTRS = %i[auctions
               auctions_without_offers
               auctions_with_offers
               offers_per_day
               average_offers_per_auction].freeze

    attr_accessor(*ATTRS)

    def initialize(start_date:, end_date:)
      @start_date = start_date
      @end_date = end_date
      ATTRS.each { |attr| send("#{attr}=", {}) }
    end

    def gather_data
      auctions_count
      daily_offers
      average_offers
    end

    def auctions_count
      data = auctions_scoped

      (start_date..end_date).each do |date|
        init_auction_report(date)

        data.each do |auction|
          if date.beginning_of_day.between?(auction.starts_at, auction.ends_at)
            @auctions[date] += 1
            increment_auction_report(auction: auction, date: date)
          end
        end
      end
    end

    def auctions_scoped
      Auction.search(where: { active_dates: (start_date..end_date).map(&:to_s) }, load: false)
    end

    def init_auction_report(date)
      @auctions[date] ||= 0
      @auctions_with_offers[date] ||= 0
      @auctions_without_offers[date] ||= 0
    end

    def increment_auction_report(auction:, date:)
      if auction.offers_count.to_i.positive?
        @auctions_with_offers[date] += 1
      else
        @auctions_without_offers[date] += 1
      end
    end

    def daily_offers
      data = auctions_scoped

      (start_date..end_date).each do |date|
        @offers_per_day[date] ||= 0
        data.each do |auction|
          if date.beginning_of_day.between?(auction.starts_at, auction.ends_at)
            @offers_per_day[date] += auction.offers_count
          end
        end
      end
    end

    def average_offers
      (start_date..end_date).each do |date|
        week_start = date.beginning_of_week
        next unless @prev_week_start.blank? || @prev_week_start != week_start

        week_end = date.end_of_week
        offers_per_week = offers_per_week(week_start: week_start, week_end: week_end)
        auctions_per_week = auctions_per_week(week_start: week_start, week_end: week_end)

        @average_offers_per_auction[week_start] = avg_bids_per_week(offers: offers_per_week,
                                                                    auctions: auctions_per_week)
        @prev_week_start = week_start
      end
    end

    def offers_per_week(week_start:, week_end:)
      @offers_per_day.select { |key, _value| key >= week_start && key <= week_end }.values.sum
    end

    def auctions_per_week(week_start:, week_end:)
      @auctions.select { |key, _value| key >= week_start && key <= week_end }.values.sum
    end

    def avg_bids_per_week(offers:, auctions:)
      if offers && auctions.to_i.positive?
        offers / (auctions * 1.0)
      else
        0
      end
    end
  end
end
