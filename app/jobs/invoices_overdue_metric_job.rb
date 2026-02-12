# frozen_string_literal: true

# Periodic job to update invoices_overdue_total metric
# Should be scheduled to run periodically (e.g., every hour via cron or whenever)
class InvoicesOverdueMetricJob < ApplicationJob
  queue_as :default

  def perform
    overdue_count = Invoice.overdue.count
    Yabeda.invoice_business.invoices_overdue_total.set({}, overdue_count)
  end
end
