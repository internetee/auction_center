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
      results = Result.unregistered
                      .joins(:auction)
                      .group_by { |result| result.auction.created_at.to_date }
      (start_date..end_date).each do |date|
        @unregistered_domains[date] = results[date].present? ? results[date].count : 0
      end
    end
  end
end
