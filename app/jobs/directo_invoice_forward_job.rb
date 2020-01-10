class DirectoInvoiceForwardJob < ApplicationJob
  def perform
    @client = init_directo_client
    @currency = Setting.find_by(code: 'auction_currency').retrieve

    invoices = Invoice.where(status: 'paid', in_directo: false).all
    invoices.each do |invoice|
      c = Directo::Customer.new
      c.code = 123

      inv = @client.invoices.new
      inv.customer = c
      inv.date = invoice.issue_date
      inv.number = invoice.number
      inv.currency = @currency
      @client.invoices.add(inv)
    end

    puts "Attempting to send invoices"
    @client.invoices.deliver
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
