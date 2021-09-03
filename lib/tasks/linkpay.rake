namespace :linkpay do
  desc 'Creates a dummy email bounce by email address'
  task :check_payment, [:order_reference, :payment_reference] => [:environment] do |_t, args|
    invoice = Invoice.find_by(id: args[:order_reference].to_i)

    unless invoice
      log "Invoice with number #{args[:order_reference]} not found"
      abort
    end

    payment_order = find_payment_order(invoice: invoice, ref: args[:payment_reference])

    payment_order.response = {
      order_reference: args[:order_reference],
      payment_reference: args[:payment_reference],
    }

    payment_order.save!
    payment_order.check_linkpay_status
  end

  private

  def find_payment_order(invoice:, ref:)
    order = invoice.payment_orders.every_pay.for_payment_reference(ref).first
    return order if order

    PaymentOrders::EveryPay.create(invoices: [invoice], user: invoice.user)
  end

  def log(msg)
    @log ||= Logger.new(STDOUT)
    @log.info(msg)
  end
end
