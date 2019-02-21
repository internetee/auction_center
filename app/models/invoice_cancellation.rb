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

      ban = Ban.create_automatic(user: user, domain_name: domain_name)
      send_email_to_offender(ban)
    end
  end

  def result
    invoice.result
  end

  def user
    invoice.user
  end

  def domain_name
    result.auction.domain_name
  end

  def send_email_to_offender(ban)
    BanMailer.ban_email(ban).deliver_later
  end
end
