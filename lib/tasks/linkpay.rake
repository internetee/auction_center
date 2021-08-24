namespace :linkpay do
  desc 'Creates a dummy email bounce by email address'
  task :check_payment, [:order_reference, :payment_reference] => [:environment] do |_t, args|
    invoice = Invoice.find_by(id: args[:order_reference].to_i)

    unless invoice
      log "Invoice with number #{args[:order_reference]} not found"
      abort
    end

    payment_order = PaymentOrders::EveryPay.create(invoices: [invoice], user: invoice.user)

    payment_order.response = {
      order_reference: linkpay_params[:order_reference],
      payment_reference: linkpay_params[:payment_reference],
    }

    payment_order.save!
    payment_order.check_linkpay_status
  end

  def log(msg)
    @log ||= Logger.new(STDOUT)
    @log.info(msg)
  end
end
