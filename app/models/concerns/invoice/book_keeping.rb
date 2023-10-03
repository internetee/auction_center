# frozen_string_literal: true

module Invoice::BookKeeping
  extend ActiveSupport::Concern

  def as_directo_json
    invoice = ActiveSupport::JSON.decode(ActiveSupport::JSON.encode(self))
    invoice = compose_invoice_meta(invoice)
    invoice['invoice_lines'] = compose_directo_product
    invoice['customer'] = compose_directo_customer

    invoice
  end

  def e_invoice_data
    invoice = as_json(only: %i[id issue_date due_date number])
    invoice['seller_name'] = seller_contact_name
    invoice['seller_reg_no'] = seller_reg_no
    invoice['seller_vat_no'] = seller_vat_no
    invoice['seller_street'] = seller_street
    invoice['seller_state'] = seller_state
    invoice['seller_zip'] = seller_zip
    invoice['seller_city'] = seller_city
    invoice['seller_country_code'] = seller_country_code
    invoice['buyer_name'] = billing_name
    invoice['buyer_vat_no'] = billing_vat_code
    invoice['buyer_street'] = street
    invoice['buyer_state'] = state
    invoice['buyer_zip'] = postal_code
    invoice['buyer_city'] = city
    invoice['buyer_country_code'] = billing_alpha_two_country_code
    invoice['total'] = price.to_f * (1 + vat_rate)
    invoice['total_to_pay'] = total.to_f
    invoice['vat_rate'] = vat_rate.to_f * 100
    invoice['currency'] = Setting.find_by(code: 'auction_currency').retrieve

    invoice
  end

  def e_invoice_sent?
    e_invoice_sent_at.present?
  end

  def do_not_send_e_invoice?
    e_invoice_sent? || cancelled?
  end

  def seller_contact_name
    Setting.find_by(code: 'invoice_issuer').retrieve
  end

  def seller_address
    country_name = Countries.name_from_alpha2_code(seller_country_code)
    [
      seller_street,
      seller_state,
      seller_zip,
      country_name,
      seller_city
    ].reject(&:blank?).compact.join(', ')
  end

  def seller_reg_no
    Setting.find_by(code: 'invoice_issuer_reg_no').retrieve
  end

  def seller_vat_no
    Setting.find_by(code: 'invoice_issuer_vat_no').retrieve
  end

  def seller_street
    Setting.find_by(code: 'invoice_issuer_street').retrieve
  end

  def seller_city
    Setting.find_by(code: 'invoice_issuer_city').retrieve
  end

  def seller_zip
    Setting.find_by(code: 'invoice_issuer_zip').retrieve
  end

  def seller_country_code
    Setting.find_by(code: 'invoice_issuer_country_code').retrieve
  end

  def seller_state
    Setting.find_by(code: 'invoice_issuer_state').retrieve
  end

  def issuer
    "#{seller_contact_name}, #{seller_address}, " \
     "Reg. no #{seller_reg_no}, VAT number #{seller_vat_no}"
  end

  private

  def compose_invoice_meta(invoice)
    invoice['issue_date'] = issue_date.strftime('%Y-%m-%d')
    invoice['transaction_date'] = paid_at.strftime('%Y-%m-%d')
    invoice['language'] = user && user&.locale == 'en' ? 'ENG' : ''
    invoice['currency'] = Setting.find_by(code: 'auction_currency').retrieve
    invoice['total_wo_vat'] = price.amount
    invoice['vat_amount'] = vat.amount

    invoice
  end

  def compose_directo_customer
    { 'name': recipient, 'destination': alpha_two_country_code,
      'vat_reg_no': vat_code,
      'code': if vat_code
                DirectoCustomer.find_or_create_by(
                  vat_number: vat_code
                ).customer_code
              else
                'ERA'
              end }.as_json
  end

  def compose_directo_product
    [
      { 'product_id': 'OKSJON',
        'description': result.auction.domain_name,
        'quantity': 1,
        'unit': 1,
        'price': ActionController::Base.helpers.number_with_precision(
          price.amount, precision: 2, separator: '.'
        ) }
    ].as_json
  end
end
