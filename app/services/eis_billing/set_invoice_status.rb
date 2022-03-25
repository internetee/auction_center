module EisBilling
  class SetInvoiceStatus
    TYPE = 'PaymentOrders::EveryPay'.freeze

    def self.ping_status(invoice)
      response = invoice.get_response_from_billing
      change_status_to_pay(response: response, invoice: invoice) if response[:status] == 'paid'
    end

    def self.change_status_to_pay(response:, invoice:)
      return unless PaymentOrder.supported_methods.include?('PaymentOrders::EveryPay'.constantize)

      return if response[:everypay_response].nil?

      everypay_response = response[:everypay_response]

      payment_order = find_payment_order(invoice: invoice, ref: everypay_response[:payment_reference])

      payment_order.response = {
        order_reference: everypay_response[:order_reference],
        payment_reference: everypay_response[:payment_reference]
      }
      payment_order.save

      if Rails.env.development? || Rails.env.test?
        CheckLinkpayStatusJob.perform_now(payment_order.id)
      else
        CheckLinkpayStatusJob.set(wait: 1.minute).perform_later(payment_order.id)
      end
    end

    def self.find_payment_order(invoice:, ref:)
      order = invoice.payment_orders.every_pay.for_payment_reference(ref).first
      return order if order

      PaymentOrders::EveryPay.create(invoices: [invoice], user: invoice.user)
    end
  end
end
