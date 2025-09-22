module Modals
  module WinnerDomain
    class Component < ApplicationViewComponent
      attr_reader :result

      def initialize(result:)
        super()

        @result = result
      end

      def registration_code_or_information
        case result.status
        when Result.statuses[:payment_received]
          result.registration_code
        when Result.statuses[:domain_registered]
          I18n.t('results.show.domain_already_registered')
        else
          I18n.t('results.show.only_available_after_paying_invoice')
        end
      end

      def pay_invoice_before
        if result.payment_received?
          I18n.t('.paid')
        elsif result&.invoice
          result.invoice.due_date
        else
          I18n.t('invoices.is_being_generated')
        end
      end
    end
  end
end
