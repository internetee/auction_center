module Concerns
  module SearchQueries
    extend ActiveSupport::Concern

    def query_by_date(klass:, query:, date_field:)
      klass.search(where: query, load: false)
           .hits
           .group_by { |invoice| invoice['_source'][date_field]&.to_date }
    end

    def active_dates_query
      { active_dates: (start_date..end_date).map(&:to_s) }
    end

    def issue_date_query
      { issue_date: (start_date..end_date).map(&:to_s) }
    end

    def result_query(status)
      { auction_ends_at: (start_date..end_date).map(&:to_s),
        status: status }
    end
  end
end
