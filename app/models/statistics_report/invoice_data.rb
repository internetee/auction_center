class StatisticsReport
  class InvoiceData
    include Concerns::WeeklyData
    attr_reader :start_date
    attr_reader :end_date
    ATTRS = %i[unpaid_invoice_percentage
               total_invoices_count
               unpaid_invoices_count
               paid_invoices_count
               total_invoices_weekly
               paid_invoices_weekly
               unpaid_invoices_weekly
               unpaid_invoice_percentage_weekly].freeze

    attr_accessor(*ATTRS)

    def initialize(start_date:, end_date:)
      @start_date = start_date
      @end_date = end_date
      ATTRS.each { |attr| send("#{attr}=", {}) }
    end

    def gather_data
      daily_data
      weekly_data
    end

    def daily_data
      invoices = invoices_query
      (start_date..end_date).each do |date|
        init_invoices_data(date)
        next unless invoices[date]

        invoices[date].each do |invoice|
          increment_invoice_data(invoice: invoice, date: date)
        end

        unpaid_invoice_percentage[date] = calculate_unpaid_percentage(date)
      end
    end

    def weekly_data
      form_weekly_data do |week_start, week_end|
        @total_invoices_weekly[week_start] = total_by_week(week_start: week_start,
                                                           week_end: week_end)
        @paid_invoices_weekly[week_start] = paid_by_week(week_start: week_start,
                                                         week_end: week_end)
        @unpaid_invoices_weekly[week_start] = unpaid_by_week(week_start: week_start,
                                                             week_end: week_end)
        calculate_unpaid_percentage_weekly(week_start)
      end
    end

    def total_by_week(week_start:, week_end:)
      @total_invoices_count.select { |key, _value| key >= week_start && key <= week_end }.values.sum
    end

    def paid_by_week(week_start:, week_end:)
      @paid_invoices_count.select { |key, _value| key >= week_start && key <= week_end }.values.sum
    end

    def unpaid_by_week(week_start:, week_end:)
      @unpaid_invoices_count.select { |key, _value| key >= week_start && key <= week_end }
                            .values.sum
    end

    def init_invoices_data(date)
      total_invoices_count[date] ||= 0
      unpaid_invoices_count[date] ||= 0
      paid_invoices_count[date] ||= 0
      unpaid_invoice_percentage[date] ||= 0
    end

    def increment_invoice_data(invoice:, date:)
      total_invoices_count[date] += 1
      case invoice.status
      when ::Invoice.statuses[:paid]
        paid_invoices_count[date] += 1
      else
        unpaid_invoices_count[date] += 1
      end
    end

    def calculate_unpaid_percentage(date)
      if @total_invoices_count[date].positive?
        @unpaid_invoices_count[date] * 100.0 / @total_invoices_count[date]
      else
        0
      end
    end

    def calculate_unpaid_percentage_weekly(date)
      if @total_invoices_weekly[date].positive?
        @unpaid_invoices_weekly[date] * 100.0 / @total_invoices_weekly[date]
      else
        0
      end
    end

    def invoices_query
      StatisticsReport::Invoice.where(issue_date: start_date..end_date)
                               .group_by { |invoice| invoice.issue_date.to_date }
    end
  end
end
