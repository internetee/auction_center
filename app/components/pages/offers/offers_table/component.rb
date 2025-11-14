module Pages
  module Offers
    module OffersTable
      class Component < ApplicationViewComponent
        attr_reader :offers

        def initialize(offers:)
          super()

          @offers = offers
        end

        def header_collection
          [{ column: 'auctions.domain_name', caption: t('auctions.domain_name'),
             options: { class: 'sorting' } },
           { column: 'auctions.platform', caption: t('auctions.type'),
             options: { class: 'sorting', style: 'width: 30px !important;' } },
           { column: nil, caption: t('offers.show.your_last_offer'), options: { class: '' } },
           { column: 'offers.created_at', caption: t('offers.created_at'),
             options: { class: 'sorting' } },
           { column: 'auctions.ends_at', caption: t('auctions.ends_at'),
             options: { class: 'sorting' } },
           { column: nil, caption: t('result_name'), options: {} },
           { column: nil, caption: t('auctions.offer_actions'), options: { style: 'width: 150px !important;' } }]
        end
      end
    end
  end
end
