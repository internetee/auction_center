module Pages
  module Offers
    module BlindAuctionOfferTable
      class Component < ApplicationViewComponent
        attr_reader :offer

        def initialize(offer:)
          super

          @offer = offer
        end

        def header_collection
          [{ column: nil, caption: t('auctions.domain_name'), options: { class: '' } },
           { column: nil, caption: t('auctions.ends_at'), options: { class: '' } },
           { column: nil, caption: t('offers.price'), options: { class: '' } }]
        end
      end
    end
  end
end
