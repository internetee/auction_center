# frozen_string_literal: true

module Concerns
  module Invoice
    module Payable
      extend ActiveSupport::Concern

      def payable?
        issued? || cancelled?
      end
    end
  end
end
