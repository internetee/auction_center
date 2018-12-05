class InvoiceCancellationJob < ApplicationJob
  def perform
    Invoice.overdue.map do |invoice|
      invoice.cancelled!
    end
  end
end
