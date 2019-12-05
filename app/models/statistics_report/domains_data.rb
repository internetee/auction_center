class StatisticsReport
  class DomainsData
    include Concerns::WeeklyData
    include Concerns::SearchQueries

    attr_reader :start_date
    attr_reader :end_date
    ATTRS = %i[unregistered_domains_daily
               registered_domains_daily
               registered_monthly
               unregistered_monthly
               registered_weekly
               unregistered_weekly
               auctions_by_end_month
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
      monthly_domains
      weekly_domains
    end

    def daily_domains
      unreg_domains = domains_query('domain_not_registered')
      reg_domains = domains_query('domain_registered')
      (start_date..end_date).each do |date|
        @unregistered_domains_daily[date] = unreg_domains[date]&.count.to_i
        @registered_domains_daily[date] = reg_domains[date]&.count.to_i
      end
    end

    def daily_auctions
      auctions = auctions_query

      (start_date..end_date).each do |date|
        @auctions_by_end_daily[date] = auctions[date]&.count.to_i
      end
    end

    def monthly_domains
      (start_date..end_date).each do |date|
        month_start = date.beginning_of_month
        next unless @prev_month_start.blank? || @prev_month_start != month_start

        month_end = date.end_of_month

        assign_monthly_data(month_start: month_start, month_end: month_end)

        registered_percent(registered_month: @registered_monthly[month(month_start)],
                           auctions_month: @auctions_by_end_month[month(month_start)],
                           month_start: month_start)

        @prev_month_start = month_start
      end
    end

    def weekly_domains
      form_weekly_data do |week_start, week_end|
        @registered_weekly[week_start] = registered_by_period(period_start: week_start,
                                                              period_end: week_end)
        @unregistered_weekly[week_start] = unregistered_by_period(period_start: week_start,
                                                                  period_end: week_end)
      end
    end

    def assign_monthly_data(month_start:, month_end:)
      @registered_monthly[month(month_start)] = registered_by_period(period_start: month_start,
                                                                     period_end: month_end)
      @auctions_by_end_month[month(month_start)] = auctions_by_period(period_start: month_start,
                                                                      period_end: month_end)
      @unregistered_monthly[month(month_start)] = unregistered_by_period(period_start: month_start,
                                                                         period_end: month_end)
    end

    def registered_by_period(period_start:, period_end:)
      @registered_domains_daily.select { |key, _value| key >= period_start && key <= period_end }
                               .values.sum || 0
    end

    def auctions_by_period(period_start:, period_end:)
      @auctions_by_end_daily.select { |key, _value| key >= period_start && key <= period_end }
                            .values.sum || 0
    end

    def unregistered_by_period(period_start:, period_end:)
      @unregistered_domains_daily.select { |key, _value| key >= period_start && key <= period_end }
                                 .values.sum || 0
    end

    def registered_percent(registered_month:, auctions_month:, month_start:)
      @registered_monthly_percent[month(month_start)] = if auctions_month.positive?
                                                          registered_month * 100.0 / auctions_month
                                                        else
                                                          0
                                                        end
    end

    def domains_query(status)
      query_by_date(klass: Result, query: result_query(status), date_field: 'auction_ends_at')
    end

    def auctions_query
      query_by_date(klass: Auction, query: active_dates_query, date_field: '\ends_at')
    end

    def month(date)
      date.strftime('%B')
    end
  end
end
