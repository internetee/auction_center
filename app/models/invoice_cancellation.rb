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

      EisBilling::SendInvoiceStatus.send_info(invoice_number: invoice.number, status: 'cancelled')
      AutomaticBan.new(invoice: invoice, user: user, domain_name: domain_name).create if user
    end
  end

  delegate :result, to: :invoice

  delegate :user, to: :invoice

  def domain_name
    result.auction.domain_name
  end
end
