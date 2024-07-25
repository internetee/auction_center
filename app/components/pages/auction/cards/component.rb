module Pages
  module Auction
    module Cards
      class Component < ApplicationViewComponent
        def faq_link
          if I18n.locale == :et
            'https://www.internet.ee/abi-ja-info/kkk#III__ee_domeenioksjonid'
          elsif I18n.locale == :en
            'https://www.internet.ee/help-and-info/faq#III__ee_domain_auctions'
          end
        end

        def reserved_domain_names_link
          if I18n.locale == :en
            'https://www.internet.ee/eif/news/auction-schedule-of-reserved-domains'
          elsif I18n.locale == :et
            'https://www.internet.ee/eis/uudised/reserveeritud-domeenide-oksjonite-kava'
          end
        end
      end
    end
  end
end
