class StatisticsReport
  class UnregisteredDomainsData
    attr_reader :start_date
    attr_reader :end_date
    ATTRS = %i[unregistered_domains].freeze

    attr_accessor(*ATTRS)

    def initialize(start_date:, end_date:)
      @start_date = start_date
      @end_date = end_date
      ATTRS.each { |attr| send("#{attr}=", {}) }
    end

    def gather_data
      results = results_query
      (start_date..end_date).each do |date|
        @unregistered_domains[date] = results[date]&.size.to_i
      end
    end

    def results_query
      StatisticsReport::Result.where(status: 'domain_not_registered')
                              .where(auction_ends_at: start_date..end_date)
                              .group_by { |result| result.auction_ends_at.to_date }
    end
  end
end
