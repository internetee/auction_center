class InvoiceCreationJob < ApplicationJob
  def perform
    Result.pending_invoice.map do |result|
      Invoice.create_from_result(result.id)
    end
  end
end
