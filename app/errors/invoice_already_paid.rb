module Errors
  class InvoiceAlreadyPaid < StandardError
    attr_reader :invoice_id, :message

    def initialize(invoice_id = nil)
      @invoice_id = invoice_id
      @message = "Invoice with id #{invoice_id} is already paid"
      super(message)
    end
  end
end
