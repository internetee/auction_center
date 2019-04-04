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

      if user
        AutomaticBan.new(user: user, domain_name: domain_name).create
      end
    end
  end

  delegate :result, to: :invoice

  delegate :user, to: :invoice

  def domain_name
    result.auction.domain_name
  end
end
