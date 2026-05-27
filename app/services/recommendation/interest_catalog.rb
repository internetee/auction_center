module Recommendation
  module InterestCatalog
    CATEGORIES = %w[
      brandable
      shop_brand
      saas
      b2b_service
      local_service
      media_content
      finance
      legal
      health
      education
      travel
      automotive
      real_estate
      numeric
      other
    ].freeze

    class << self
      def categories = CATEGORIES
    end
  end
end
