class InvoiceCreator
  attr_reader :result_id
  attr_reader :result
  attr_reader :invoice

  def initialize(result_id)
    @result_id = result_id
  end

  def call
    @result = Result.find_by(id: result_id)
    return unless result_present?
    return unless result_awaiting_payment?
    return unless result_user

    return result.invoice if invoice_already_present?

    create_invoice
    invoice
  end

  private

  delegate :present?, to: :result, prefix: true
  delegate :awaiting_payment?, to: :result, prefix: true
  delegate :offer, to: :result, prefix: true
  delegate :user, to: :result, prefix: true
  delegate :auction, to: :result, prefix: true

  def invoice_already_present?
    result.invoice.present?
  end

  def assign_invoice_associations
    invoice.result = result
    invoice.user = result.user
    invoice.billing_profile = result_offer.billing_profile
  end

  def assign_price
    invoice.cents = result_offer.cents
    invoice.invoice_items = [
      InvoiceItem.new(invoice: invoice,
                      cents: result_offer.cents,
                      name: I18n.t('invoice_items.name',
                                   domain_name: result_auction.domain_name,
                                   auction_end: result_auction.ends_at.to_date,
                                   locale: I18n.default_locale)),
    ]
  end

  def set_issue_and_due_date
    invoice.issue_date = Time.zone.today
    invoice.due_date = Time.zone.today + Setting.find_by(code: 'payment_term').retrieve
  end

  def create_invoice
    @invoice = Invoice.new

    ActiveRecord::Base.transaction do
      assign_invoice_associations
      assign_price
      set_issue_and_due_date

      invoice.save
    end
  end
end
