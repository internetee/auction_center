module Modals
  module PayInvoice
    class Component < ApplicationViewComponent
      attr_reader :invoice

      def initialize(invoice:)
        super

        @invoice = invoice
      end
    end
  end
end