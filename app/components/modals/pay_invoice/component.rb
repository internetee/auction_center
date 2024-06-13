module Modals
  module PayInvoice
    class Component < ApplicationViewComponent
      attr_reader :invoice

      def initialize(invoice:)
        super

        @invoice = invoice
      end

      def amount_field_properties
        {
          attribute: :amount,
          options: {
            min: 0.0,
            step: 0.01,
            value: number_with_precision(invoice.due_amount.to_f, precision: 2, delimiter: '', separator: '.'),
            disabled: false
          }
        }
      end
    end
  end
end