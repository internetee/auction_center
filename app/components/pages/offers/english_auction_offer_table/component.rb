module Pages
  module Offers
    module EnglishAuctionOfferTable
      class Component < ApplicationViewComponent
        attr_reader :offer

        def initialize(offer:)
          super

          @offer = offer
        end

        def overview_table_headers
          [{ column: nil, caption: t('auctions.domain_name'), options: { class: '' } },
           { column: nil, caption: t('auctions.ends_at'), options: { class: '' } },
           { column: nil, caption: t('offers.price'), options: { class: '' } },
           { column: nil, caption: t('offers.total'), options: { class: '' } }]
        end

        def bidder_table_headers
          [{ column: nil, caption: t('offers.show.participants'), options: { class: '' } },
           { column: nil, caption: t('offers.show.your_last_offer'), options: { class: '' } },
           { column: nil, caption: t('offers.show.offers_time'), options: { class: '' } }]
        end

        def deposit_payment_table_headers
          [{ column: nil, caption: t('offers.show.deposit_participants'), options: { class: '' } },
           { column: nil, caption: t('offers.show.offers_time'), options: { class: '' } }]
        end
      end
    end
  end
end
