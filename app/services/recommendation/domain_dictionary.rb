module Recommendation
  module DomainDictionary
    # Maps a root token -> InterestCatalog category symbol.
    # Sources: Estonian common-noun domains we already see in seeds, English
    # SaaS/marketing vocabulary, common shop/service terms. Grow over time
    # as Tier 2 (LLM) reveals new patterns.
    ESTONIAN_ROOTS = {
      'kohvik' => :local_service, 'kohv' => :local_service,
      'apteek' => :health, 'arst' => :health, 'tervis' => :health, 'med' => :health,
      'pood' => :shop_brand, 'aiapood' => :shop_brand, 'kalapood' => :shop_brand,
      'raamatupood' => :shop_brand, 'veebipood' => :shop_brand, 'mobiilipood' => :shop_brand,
      'kinnisvara' => :real_estate, 'maja' => :real_estate, 'korter' => :real_estate,
      'laen' => :finance, 'pank' => :finance, 'raha' => :finance,
      'jurist' => :legal, 'oigus' => :legal, 'oigusabi' => :legal, 'notar' => :legal,
      'haridus' => :education, 'kool' => :education, 'koolitus' => :education,
      'reisid' => :travel, 'matk' => :travel, 'majutus' => :travel, 'reisi' => :travel,
      'auto' => :automotive, 'autod' => :automotive, 'rent' => :automotive,
      'ilusalong' => :health, 'kosmeetika' => :health, 'spaa' => :health,
      'meedia' => :media_content, 'uudised' => :media_content, 'ajakiri' => :media_content,
      'remont' => :local_service, 'parandus' => :local_service, 'ehitus' => :local_service,
      'tooriistad' => :shop_brand, 'mood' => :shop_brand, 'lilled' => :shop_brand,
      'turundus' => :b2b_service, 'nouv' => :b2b_service,
      'tarkvara' => :saas, 'saasplatvorm' => :saas, 'platvorm' => :saas, 'pilv' => :saas
    }.freeze

    ENGLISH_ROOTS = {
      # Shop / commerce
      'shop' => :shop_brand, 'store' => :shop_brand, 'market' => :shop_brand,
      'marketplace' => :shop_brand, 'mart' => :shop_brand, 'deal' => :shop_brand,
      'dealzone' => :shop_brand, 'foodmarket' => :shop_brand, 'shopline' => :shop_brand,

      # SaaS / tech
      'saas' => :saas, 'cloud' => :saas, 'cloudstack' => :saas, 'tech' => :saas,
      'soft' => :saas, 'software' => :saas, 'app' => :saas, 'apps' => :saas,
      'stack' => :saas, 'platform' => :saas, 'flow' => :saas, 'forge' => :saas,
      'craft' => :saas, 'pixelcraft' => :saas, 'lab' => :saas, 'hub' => :saas,
      'desk' => :saas, 'suite' => :saas, 'gamesuite' => :saas, 'tools' => :saas,
      'data' => :saas, 'api' => :saas, 'dev' => :saas, 'devkit' => :saas,
      'workzone' => :saas, 'startupdesk' => :saas,

      # Finance
      'fin' => :finance, 'finance' => :finance, 'fintech' => :finance, 'fintechlab' => :finance,
      'bank' => :finance, 'pay' => :finance, 'invest' => :finance, 'loan' => :finance,
      'crypto' => :finance, 'capital' => :finance, 'accountflow' => :finance,

      # B2B
      'b2b' => :b2b_service, 'agency' => :b2b_service, 'consult' => :b2b_service,
      'enterprise' => :b2b_service, 'pro' => :b2b_service, 'corp' => :b2b_service,
      'growth' => :b2b_service, 'growthhub' => :b2b_service, 'marketflow' => :b2b_service,

      # Media / content
      'media' => :media_content, 'mediateam' => :media_content,
      'news' => :media_content, 'blog' => :media_content, 'press' => :media_content,
      'magazine' => :media_content,

      # Legal
      'legal' => :legal, 'legalhub' => :legal, 'lawyer' => :legal, 'law' => :legal,

      # Health
      'health' => :health, 'wellness' => :health, 'wellnesshub' => :health,
      'medic' => :health, 'pharma' => :health, 'clinic' => :health, 'fit' => :health,

      # Education
      'edu' => :education, 'school' => :education, 'academy' => :education,
      'course' => :education, 'learn' => :education,

      # Travel
      'travel' => :travel, 'traveldesk' => :travel, 'trip' => :travel, 'tour' => :travel,
      'hotel' => :travel, 'flight' => :travel, 'booking' => :travel,

      # Automotive
      'car' => :automotive, 'carshop' => :automotive, 'auto' => :automotive,
      'motor' => :automotive, 'drive' => :automotive,

      # Real estate
      'property' => :real_estate, 'propertylab' => :real_estate, 'realty' => :real_estate,
      'estate' => :real_estate, 'rent' => :real_estate, 'lease' => :real_estate,
      'home' => :real_estate, 'house' => :real_estate,

      # Brandable / generic positive
      'brand' => :brandable, 'brandforge' => :brandable, 'premium' => :brandable
    }.freeze

    ALL_ROOTS = ESTONIAN_ROOTS.merge(ENGLISH_ROOTS).freeze

    # Roots sorted by length DESC for greedy longest-prefix matching.
    SORTED_ROOTS = ALL_ROOTS.keys.sort_by { |k| -k.length }.freeze

    MIN_TOKEN_LENGTH = 3

    class << self
      def lookup(token)
        ALL_ROOTS[token.to_s.downcase]
      end

      def known?(token)
        ALL_ROOTS.key?(token.to_s.downcase)
      end

      # Greedy subword tokenization: from the front, consume the longest
      # known root. Falls back to consuming a single character so we always
      # make progress and never loop.
      def tokenize(bare_name)
        name = bare_name.to_s.downcase
        return [] if name.empty?

        tokens = []
        index = 0

        while index < name.length
          remaining = name[index..]
          matched_root = SORTED_ROOTS.find do |root|
            root.length >= MIN_TOKEN_LENGTH && remaining.start_with?(root)
          end

          if matched_root
            tokens << matched_root
            index += matched_root.length
          else
            # No known root at this position; consume the next contiguous
            # alphabetic run as a single unknown token, or skip a non-letter.
            run_match = remaining.match(/\A[a-z]+/)
            if run_match
              tokens << run_match[0]
              index += run_match[0].length
            else
              index += 1
            end
          end
        end

        tokens
      end
    end
  end
end
