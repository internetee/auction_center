class InvoiceCancellationJob < ApplicationJob
  def perform
    Invoice.overdue.map(&:cancel)
  end

  def self.needs_to_run?
    Invoice.overdue.any?
  end
end
