module Admin
  class StatisticsController < BaseController

    before_action :authorize_user

    # GET /admin/statistics
    def index
      start_date = index_params[:start_date] || Time.zone.yesterday
      end_date = index_params[:start_date] || Time.zone.today
      report = StatisticsReport.new(start_date: start_date, end_date: end_date)
      report.gather_data
      @data = {}
      StatisticsReport::ATTRS.each do |attr|
        @data[attr] = report.send(attr)
      end
    end

    private

    def index_params
      {}
      # params.require(:statistics_report).permit(:start_date, :end_date)
    end

    def authorize_user
      authorize! :read, StatisticsReport
    end
  end
end
