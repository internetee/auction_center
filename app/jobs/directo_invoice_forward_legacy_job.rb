# # frozen_string_literal: true

# class DirectoInvoiceForwardLegacyJob < ApplicationJob
#   I18n.locale = :en

#   def perform
#     @client = init_directo_client
#     @currency = Setting.find_by(code: 'auction_currency').retrieve

#     invoices = Invoice.where(status: 'paid', in_directo: false)
#     return unless invoices.any?

#     invoices.find_each do |invoice|
#       @client.invoices.add_with_schema(schema: 'auction',
#                                        invoice: invoice.as_directo_json)
#     end
#     logger.info "Attempting to send #{invoices.count} invoice(s) to Directo"
#     sync_with_directo
#   end

#   def sync_with_directo
#     logger.info @client.invoices.as_xml
#     res = @client.invoices.deliver(ssl_verify: false)
#     logger.info "Directo responded with code #{res.code}"
#     update_invoice_directo_state(res.body, res.code)
#   rescue SocketError, Errno::ECONNREFUSED, Timeout::Error, Errno::EINVAL,
#          Errno::ECONNRESET, EOFError, Net::HTTPBadResponse,
#          Net::HTTPHeaderSyntaxError, Net::ProtocolError
#     logger.info('Network exception when connecting to Directo')
#   end

#   def update_invoice_directo_state(xml, code)
#     logger.info "Directo responded with body: #{xml}"
#     return if code != '200'

#     pushed_invoices = []
#     Nokogiri::XML(xml).css('Result').each do |result|
#       inv_no = result.attributes['docid'].value.to_i
#       (pushed_invoices << inv_no) if invoice_reported_as_valid?(result)
#     end
#     mark_invoices_as_synced(invoice_ids: pushed_invoices)
#   end

#   def invoice_reported_as_valid?(result)
#     inv_no = result.attributes['docid'].value.to_i
#     result_type = result.attributes['Type'].value.to_i
#     result_desc = result.attributes['Desc'].value
#     (return true) if result_type.zero?

#     logger.info "Not marking invoice ##{inv_no} as sent. Desc: #{result_desc}"
#     false
#   end

#   def mark_invoices_as_synced(invoice_ids:)
#     Invoice.where(number: invoice_ids).update(in_directo: true)
#     logger.info "Marked #{invoice_ids.count} invoices as synced to directo"
#   end

#   def init_directo_client
#     api_url = Setting.find_by(code: 'directo_api_url').retrieve
#     sales_agent = Setting.find_by(code: 'directo_sales_agent').retrieve
#     payment_terms = Setting.find_by(
#       code: 'directo_default_payment_terms'
#     ).retrieve

#     DirectoApi::Client.new(api_url, sales_agent, payment_terms)
#   end

#   def self.needs_to_run?
#     Setting.find_by(code: 'directo_integration_enabled').retrieve
#   end
# end
