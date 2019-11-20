class StatisticsReport
  class InvoiceData
    attr_reader :start_date
    attr_reader :end_date
    ATTRS = %i[unpaid_invoice_percentage
               total_invoices_count
               unpaid_invoices_count
               paid_invoices_count].freeze

    attr_accessor(*ATTRS)

    def initialize(start_date:, end_date:)
      @start_date = start_date
      @end_date = end_date
      ATTRS.each { |attr| send("#{attr}=", {}) }
    end

    def gather_data
      invoices_by_date = Invoice.where(issue_date: start_date..end_date).group_by(&:issue_date)
      (start_date..end_date).each do |date|
        invoices = invoices_by_date[date]
        init_invoices_data(date)
        next unless invoices

        invoices.each do |invoice|
          increment_invoice_data(invoice: invoice, date: date)
        end

        unpaid_invoice_percentage[date] = calculate_unpaid_percentage(date)
      end
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
      when Invoice.statuses[:paid]
        paid_invoices_count[date] += 1
      else
        unpaid_invoices_count[date] += 1
      end
    end

    def calculate_unpaid_percentage(date)
      if total_invoices_count[date].positive?
        unpaid_invoices_count[date] * 100.0 / total_invoices_count[date]
      else
        0
      end
    end
  end
end
