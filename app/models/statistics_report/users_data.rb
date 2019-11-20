class StatisticsReport
  class UsersData
    attr_reader :start_date
    attr_reader :end_date
    ATTRS = %i[users].freeze

    attr_accessor(*ATTRS)

    def initialize(start_date:, end_date:)
      @start_date = start_date
      @end_date = end_date
      ATTRS.each { |attr| send("#{attr}=", {}) }
    end

    def gather_data
      @users = User.joins(:results)
                   .group('users.given_names')
                   .count
                   .sort_by { |_key, value| value }
                   .to_h
    end
  end
end
