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
        @unregistered_domains[date] = results[date]&.count.to_i
      end
    end

    def results_query
      Result.search(where: { auction_ends_at: (start_date..end_date).map(&:to_s),
                             status: 'domain_not_registered' },
                    load: false)
            .hits
            .group_by { |result| result['_source']['auction_ends_at'].to_date }
    end
  end
end
