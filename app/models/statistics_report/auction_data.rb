class StatisticsReport
  class AuctionData
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
      data = Auction.active_for_period(start_date, end_date).includes(:offers).preload(:offers)

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

    def auction_sql

    end

    def init_auction_report(date)
      @auctions[date] ||= 0
      @auctions_with_offers[date] ||= 0
      @auctions_without_offers[date] ||= 0
    end

    def increment_auction_report(auction:, date:)
      if auction.offers.size.positive?
        @auctions_with_offers[date] += 1
      else
        @auctions_without_offers[date] += 1
      end
    end

    def daily_offers
      data = Auction.active_for_period(start_date, end_date).includes(:offers).preload(:offers)

      (start_date..end_date).each do |date|
        @offers_per_day[date] ||= 0
        data.each do |auction|
          if date.beginning_of_day.between?(auction.starts_at, auction.ends_at)
            @offers_per_day[date] += auction.offers.size
          end
        end
      end
    end

    def average_offers
      (start_date..end_date).each do |date|
        @average_offers_per_auction[date] = \
          if @offers_per_day[date] && @auctions[date].to_i.positive?
            @offers_per_day[date] / (@auctions[date] * 1.0)
          else
            0
          end
      end
    end
  end
end
