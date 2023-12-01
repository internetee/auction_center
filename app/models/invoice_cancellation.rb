class InvoiceCancellation
  attr_reader :invoice

  def initialize(invoice)
    @invoice = invoice
  end

  def cancel
    return unless invoice.overdue?

    ActiveRecord::Base.transaction do
      result.payment_not_received!
      invoice.cancelled!

      response = EisBilling::SendInvoiceStatusService.call(invoice_number: invoice.number,
                                                           status: 'overdue')
      raise ActiveRecord::Rollback, response.errors unless response.result?

      AutomaticBan.new(invoice:, user:, domain_name:).create if user
    end
  end

  delegate :result, to: :invoice

  delegate :user, to: :invoice

  def domain_name
    result.auction.domain_name
  end
end
