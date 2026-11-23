module PaymentOrders
  # Montonio payment links are created by the billing system (eis_billing_system), which also
  # receives the Montonio webhook and forwards the settlement to us via
  # PUT /eis_billing/payment_status. Therefore this payment order only implements the
  # settlement half of the flow - there is no checkout form, no HMAC and no configuration.
  class Montonio < PaymentOrder
    CONFIG_NAMESPACE = 'montonio'.freeze

    SUCCESSFUL_PAYMENT = %w[settled].freeze

    def self.config_namespace_name
      CONFIG_NAMESPACE
    end

    # Perform necessary checks and mark the invoice as paid
    def mark_invoice_as_paid
      return unless settled_payment?

      response.with_indifferent_access
      paid!
      time = response['transaction_time'].to_datetime

      Invoice.transaction do
        invoices.each do |invoice|
          invoice.mark_as_paid_at_with_payment_order(time, self)
        end
      end
    end

    # Check if the intermediary reports payment as settled and we can expect money on
    # our accounts
    def settled_payment?
      SUCCESSFUL_PAYMENT.include?(response['payment_state'])
    end
  end
end
