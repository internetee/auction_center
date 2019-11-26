class StatisticsReport
  class DomainsData
    attr_reader :start_date
    attr_reader :end_date
    ATTRS = %i[unregistered_domains_daily
               registered_domains_daily
               auctions_by_end_daily
               registered_monthly_percent].freeze

    attr_accessor(*ATTRS)

    def initialize(start_date:, end_date:)
      @start_date = start_date
      @end_date = end_date
      ATTRS.each { |attr| send("#{attr}=", {}) }
    end

    def gather_data
      daily_domains
      daily_auctions
      monthly_registered_domains
    end

    def daily_domains
      (start_date..end_date).each do |date|
        @unregistered_domains_daily[date] = unregistered_domains[date]&.count.to_i
        @registered_domains_daily[date] = registered_domains[date]&.count.to_i
      end
    end

    def daily_auctions
      auctions = Auction.all.joins(:result).group_by{ |auction| auction.ends_at.to_date }
      (start_date..end_date).each do |date|
        @auctions_by_end_daily[date] = auctions[date]&.count.to_i
      end
    end

    def monthly_registered_domains
      (start_date..end_date).each do |date|
        month_start = date.beginning_of_month
        next unless @prev_month_start.blank? || @prev_month_start != month_start

        month_end = date.end_of_month

        registered_month = registered_month(month_start: month_start, month_end: month_end)
        auctions_month = auctions_month(month_start: month_start, month_end: month_end)

        registered_percent(registered_month: registered_month,
                           auctions_month: auctions_month,
                           month_start: month_start)

        @prev_month_start = month_start
      end
    end

    def registered_month(month_start:, month_end:)
      @registered_domains_daily.select { |key, _value| key >= month_start && key <= month_end }
                               .values.sum || 0
    end

    def auctions_month(month_start:, month_end:)
      @auctions_by_end_daily.select { |key, _value| key >= month_start && key <= month_end }
                            .values.sum || 0
    end

    def registered_percent(registered_month:, auctions_month:, month_start:)
      month = month_start.strftime("%B")
      @registered_monthly_percent[month] = if auctions_month.positive?
                                             registered_month * 100.0 / auctions_month
                                           else
                                             0
                                           end
    end

    def unregistered_domains
      Result.unregistered
            .joins(:auction)
            .where(auctions: { ends_at: start_date.beginning_of_day..end_date.end_of_day })
            .preload(:auction)
            .group_by { |result| result.auction.ends_at.to_date }
    end

    def registered_domains
      Result.registered.joins(:auction)
            .where(auctions: { ends_at: start_date.beginning_of_day..end_date.end_of_day })
            .preload(:auction)
            .group_by { |result| result.auction.ends_at.to_date }
    end
  end
end
