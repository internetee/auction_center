class StatisticsReport
  attr_reader :start_date
  attr_reader :end_date

  REPORTS_KLASSES = [StatisticsReport::AuctionData,
                     StatisticsReport::UnregisteredDomainsData,
                     StatisticsReport::InvoiceData,
                     StatisticsReport::DomainsData,
                     StatisticsReport::UsersData].freeze

  ATTRS = REPORTS_KLASSES.map { |klass| klass::ATTRS }.flatten.freeze

  attr_accessor(*ATTRS)

  def initialize(start_date:, end_date:)
    @start_date = start_date.to_date
    @end_date = end_date.to_date
    ATTRS.each { |attr| send("#{attr}=", {}) }
  end

  def gather_data
    REPORTS_KLASSES.each do |report_klass|
      report = report_klass.new(start_date: start_date, end_date: end_date)
      report.gather_data
      report_klass::ATTRS.each do |attr|
        send("#{attr}=", report.send(attr))
      end
    end
  end
end
