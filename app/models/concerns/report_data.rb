module Concerns
  module ReportData
    extend ActiveSupport::Concern

    def form_weekly_data
      (start_date..end_date).each do |date|
        week_start = date.beginning_of_week
        next unless @prev_week_start.blank? || @prev_week_start != week_start

        week_end = date.end_of_week

        yield week_start, week_end

        @prev_week_start = week_start
      end
    end

    def auctions_query
      StatisticsReport::Auction.where('starts_at <= ? AND ends_at >= ?', end_date, start_date)
                               .group_by { |auction| auction.ends_at.to_date }
    end
  end
end
