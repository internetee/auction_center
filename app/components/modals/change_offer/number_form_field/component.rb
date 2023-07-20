module Modals
  module ChangeOffer
    module NumberFormField
      class Component < ApplicationViewComponent
        attr_reader :offer_value, :offer_disabled

        def initialize(offer_value:, offer_disabled:)
          super

          @offer_value = offer_value
          @offer_disabled = offer_disabled
        end
      end
    end
  end
end