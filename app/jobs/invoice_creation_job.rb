class InvoiceCreationJob < ApplicationJob
  def perform
    Result.pending_invoice.map do |result|
      Invoice.create_from_result(result.id)
    end
  end

  def self.needs_to_run?
    Result.pending_invoice.any?
  end
end
