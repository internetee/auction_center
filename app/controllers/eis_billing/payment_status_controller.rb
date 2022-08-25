module EisBilling
  class PaymentStatusController < EisBilling::BaseController
    def update
      invoice = ::Invoice.find_by(number: params[:order_reference])
      payment_reference = params[:payment_reference]

      if params[:invoice_number_collection].nil?
        payment_process(invoice: invoice, payment_reference: payment_reference) unless invoice.nil?
      else
        pay_mulitply(params[:invoice_number_collection])
      end

      respond_to do |format|
        format.json do
          render status: :ok, content_type: 'application/json', layout: false,
                 json: { message: 'ok' }
        end
      end
    end

    private

    def pay_mulitply(data)      
      return if data.empty?

      data.each do |d|
        invoice = ::Invoice.find_by(number: d[:number])
        payment_process(invoice: invoice, payment_reference: d[:payment_reference])
      end
    end

    def payment_process(invoice:, payment_reference:)
      payment_order = PaymentOrder.find_by(invoice_id: invoice.id)

      if payment_order.nil?
        payment_order = PaymentOrders::EveryPay.create(invoices: [invoice], user: invoice.user)
      end

      payment_order.response = params
      payment_order.save
      payment_order.mark_invoice_as_paid
    end

    def find_payment_order(invoice:, ref:)
      order = invoice.payment_orders.every_pay.for_payment_reference(ref).first
      return order if order

      PaymentOrders::EveryPay.create(invoices: [invoice], user: invoice.user)
    end

    def linkpay_params
      params.permit(:order_reference, :payment_reference)
    end
  end
end
