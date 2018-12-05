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
    return unless result_sold?
    return unless result_user

    return result.invoice if invoice_already_present?

    create_invoice
    invoice
  end

  private

  delegate :present?, to: :result, prefix: true
  delegate :sold?, to: :result, prefix: true
  delegate :offer, to: :result, prefix: true
  delegate :user, to: :result, prefix: true

  def invoice_already_present?
    result.invoice.present?
  end

  def create_invoice
    @invoice = Invoice.new

    ActiveRecord::Base.transaction do
      invoice.result = result
      invoice.user = result.user
      invoice.cents = result_offer.cents
      invoice.billing_profile = result_offer.billing_profile

      invoice.issue_date = Time.zone.today
      invoice.due_date = Time.zone.today + Setting.payment_term

      invoice.save
    end
  end
end
