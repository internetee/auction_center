# frozen_string_literal: true

module Concerns
  module Invoice
    module Payable
      extend ActiveSupport::Concern

      def payable?
        issued? || cancelled_and_have_valid_ban?
      end

      private

      def cancelled_and_have_valid_ban?
        cancelled? && Ban.valid.where(invoice_id: id).present?
      end
    end
  end
end
