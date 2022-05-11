class StatisticsReport
  class UsersData
    attr_reader :start_date
    attr_reader :end_date
    ATTRS = %i[users winners_by_country].freeze

    attr_accessor(*ATTRS)

    def initialize(start_date:, end_date:)
      @start_date = start_date
      @end_date = end_date
      ATTRS.each { |attr| send("#{attr}=", {}) }
    end

    def gather_data
      users_data
      geo_data
    end

    def users_data
      @users = User.joins(:results)
                   .group('users.given_names')
                   .size
                   .sort_by { |_key, value| value }
                   .to_h
    end

    def geo_data
      @winners_by_country = User.joins(:results).group('alpha_two_country_code').size
    end
  end
end
