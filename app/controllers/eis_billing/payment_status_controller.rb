module EisBilling
  class PaymentStatusController < EisBilling::BaseController
    def update
      # TODO
      # check_for_deposit(params) if params[:auction_name].present? && params[:user_email].present?

      invoice = ::Invoice.find_by(number: params[:order_reference])
      define_payment_option(invoice: invoice)

      respond_to do |format|
        format.json do
          render status: :ok, content_type: 'application/json', layout: false,
                 json: { message: 'ok' }
        end
      end
    end

    private

    def check_for_deposit(params)
      EisBilling::CheckForDepositService.send(auction_name: params[:auction_name], user_uuid: params[:user_uuid])
    end

    def define_payment_option(invoice:)
      if params[:invoice_number_collection].nil?
        payment_process(invoice: invoice) unless invoice.nil?
      else
        pay_mulitply(params[:invoice_number_collection])
      end
    end

    def pay_mulitply(data)
      return if data.empty?

      data.each do |d|
        invoice = ::Invoice.find_by(number: d[:number])
        payment_process(invoice: invoice)
      end
    end

    def payment_process(invoice:)
      payment_order = PaymentOrder.find_by(invoice_id: invoice.id) ||
                      PaymentOrders::EveryPay.create(invoices: [invoice], user: invoice.user)

      payment_order.response = params
      payment_order.save
      payment_order.mark_invoice_as_paid
    end

    def linkpay_params
      params.permit(:order_reference)
    end
  end
end
