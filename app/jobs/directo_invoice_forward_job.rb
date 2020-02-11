# frozen_string_literal: true

class DirectoInvoiceForwardJob < ApplicationJob
  def perform
    @client = init_directo_client
    @currency = Setting.find_by(code: 'auction_currency').retrieve

    invoices = Invoice.where(status: 'paid', in_directo: false).all
    return unless invoices.any?

    invoices.each do |invoice|
      @client.invoices.add(generate_directo_invoice(invoice: invoice,
                                                    client: @client))
    end
    logger.info "Attempting to send #{invoices.count} invoice(s) to Directo"
    sync_with_directo
  end

  def sync_with_directo
    res = @client.invoices.deliver(ssl_verify: false)
    logger.info "Directo responded with code #{res.code}"
    update_invoice_directo_state(res.body) if res.code == '200'
  rescue SocketError, Errno::ECONNREFUSED, Timeout::Error, Errno::EINVAL,
         Errno::ECONNRESET, EOFError, Net::HTTPBadResponse,
         Net::HTTPHeaderSyntaxError, Net::ProtocolError
    logger.info('Network exception when connecting to Directo')
  end

  def update_invoice_directo_state(xml)
    pushed_invoices = []
    Nokogiri::XML(xml).css('Result').each do |result|
      inv_no = result.attributes['docid'].value.to_i
      (pushed_invoices << inv_no) if invoice_reported_as_valid?(result)
    end
    mark_invoices_as_synced(invoice_ids: pushed_invoices)
  end

  def invoice_reported_as_valid?(result)
    inv_no = result.attributes['docid'].value.to_i
    result_type = result.attributes['Type'].value.to_i
    result_desc = result.attributes['Desc'].value
    (return true) if result_type.zero?

    logger.info "Not marking invoice ##{inv_no} as sent. Desc: #{result_desc}"
    false
  end

  def mark_invoices_as_synced(invoice_ids:)
    Invoice.where(number: invoice_ids).update(in_directo: true)
    logger.info "Marked #{invoice_ids.count} invoices as synced to directo"
  end

  def generate_directo_invoice(invoice:, client:)
    inv = client.invoices.new
    inv = create_invoice_meta(directo_invoice: inv, invoice: invoice)
    inv = create_invoice_line(invoice: invoice, directo_invoice: inv)

    inv
  end

  def create_invoice_meta(directo_invoice:, invoice:)
    directo_invoice.customer = create_invoice_customer(invoice: invoice)
    directo_invoice.date = invoice.issue_date
    directo_invoice.transaction_date = invoice.paid_at
    directo_invoice.number = invoice.number
    directo_invoice.currency = @currency
    directo_invoice.vat_amount = invoice.vat
    directo_invoice.total_wo_vat = invoice.price
    directo_invoice.language = 'ENG'

    directo_invoice
  end

  def create_invoice_customer(invoice:)
    customer = Directo::Customer.new
    customer.code = 'ERA'
    if invoice.vat_code.present?
      customer.code = DirectoCustomer.find_or_create_by(
        vat_number: invoice.vat_code
      ).customer_code
    end
    customer.name = invoice.recipient

    customer
  end

  def create_invoice_line(invoice:, directo_invoice:)
    line = directo_invoice.lines.new
    line.code = 'OKSJON'
    line.description = invoice.result.auction.domain_name
    line.vat_number = 10
    line.quantity = 1
    line.unit = 1
    line.price = invoice.price
    directo_invoice.lines.add(line)

    directo_invoice
  end

  def init_directo_client
    api_url = Setting.find_by(code: 'directo_api_url').retrieve
    sales_agent = Setting.find_by(code: 'directo_sales_agent').retrieve
    payment_terms = Setting.find_by(code: 'directo_default_payment_terms').retrieve

    Directo::Client.new(api_url, sales_agent, payment_terms)
  end

  def self.needs_to_run?
    Setting.find_by(code: 'directo_integration_enabled').retrieve
  end
end
