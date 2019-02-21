class InvoiceCancellationJob < ApplicationJob
  def perform
    Invoice.overdue.map do |invoice|
      InvoiceCancellation.new(invoice).cancel
    end
  end

  def self.needs_to_run?
    Invoice.overdue.any?
  end
end
