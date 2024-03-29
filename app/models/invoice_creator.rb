class InvoiceCreator
  attr_reader :result_id, :result, :invoice

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
    send_invoice_to_billing_system(invoice)
    mark_as_paid_if_sum_is_zero
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
    invoice.billing_name = result_offer.billing_profile.name
    invoice.billing_address = result_offer.billing_profile.address
    invoice.billing_vat_code = result_offer.billing_profile.vat_code
    invoice.billing_alpha_two_country_code = result_offer.billing_profile.alpha_two_country_code
  end

  def send_invoice_to_billing_system(invoice)
    response = EisBilling::Invoice.call(invoice:)
    if response.result?
      link = response.instance['everypay_link']
      invoice.update(payment_link: link)
    else
      response.errors
    end
  end

  def assign_price
    invoice.cents = result_offer.cents
    invoice.invoice_items = [assign_invoice_item]
  end

  def assign_billing_address
    billing_fields = %w[vat_code street city postal_code alpha_two_country_code]
    invoice.recipient = invoice.billing_profile.name

    invoice.billing_profile.attributes.keys.each do |attribute|
      invoice[attribute] = invoice.billing_profile[attribute] if billing_fields.include? attribute
    end
  end

  def set_issue_and_due_date
    invoice.issue_date = Time.zone.today
    invoice.due_date = Time.zone.today + Setting.find_by(code: 'payment_term').retrieve
    invoice.due_date += result_auction.english? ? 1.day : 0.day
  end

  def create_invoice
    @invoice = Invoice.new

    ActiveRecord::Base.transaction do
      assign_invoice_associations
      invoice.vat_rate = assign_vat_rate
      result_auction.enable_deposit ? assign_price_with_deposit : assign_price
      set_issue_and_due_date
      assign_billing_address

      invoice.save
    end
  end

  def assign_price_with_deposit
    invoice.cents = result_offer.cents
    invoice.invoice_items = [assign_invoice_item]
  end

  def assign_invoice_item
    InvoiceItem.new(invoice:,
                    cents: result_offer.cents,
                    name: I18n.t('invoice_items.name',
                                 domain_name: result_auction.domain_name,
                                 auction_end: result_auction.ends_at.to_date,
                                 locale: I18n.default_locale))
  end

  def mark_as_paid_if_sum_is_zero
    return unless invoice.total.zero?

    invoice.mark_as_paid_at(Time.zone.now)
  end

  def assign_vat_rate
    if invoice.billing_alpha_two_country_code == 'EE'
      return BigDecimal(Setting.find_by(code: :estonian_vat_rate).retrieve,
                        2)
    end

    return BigDecimal('0') if invoice.vat_code.present?

    Countries.vat_rate_from_alpha2_code(invoice.billing_alpha_two_country_code)
  end
end
