class StatisticsReport
  class DomainsData
    attr_reader :start_date
    attr_reader :end_date
    ATTRS = %i[unregistered_domains_count_by_end
               registered_domains_count_by_end].freeze

    attr_accessor(*ATTRS)

    def initialize(start_date:, end_date:)
      @start_date = start_date
      @end_date = end_date
      ATTRS.each { |attr| send("#{attr}=", {}) }
    end

    def gather_data
      unregistered_domains = Result.unregistered
                                   .joins(:auction)
                                   .group_by { |result| result.auction.ends_at.to_date }
      registered_domains = Result.registered
                                 .joins(:auction)
                                 .group_by { |result| result.auction.ends_at.to_date }

      (start_date..end_date).each do |date|
        unregistered_domains_count_by_end[date] = unregistered_domains[date]&.count.to_i
        registered_domains_count_by_end[date] = registered_domains[date]&.count.to_i
      end
    end
  end
end
