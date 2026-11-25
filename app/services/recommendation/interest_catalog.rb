module Recommendation
  # Single source of truth for the interest-category vocabulary.
  #
  # Categories are admin-managed (InterestCategory table). This module is the
  # read API used by the user form, the LLM classifier (category enum), the
  # scorer, and the sort. Because every consumer reads `categories` from here,
  # adding a category in admin automatically widens the LLM vocabulary and the
  # scoring match — no code change needed.
  #
  # FALLBACK_CATEGORIES is used only when the table is empty or unavailable
  # (fresh DB before seeding, or mid-migration) so classification and scoring
  # never break. The table holds ~15 rows queried over an (active, position)
  # index, so reads are cheap and uncached — avoids cross-process staleness.
  module InterestCatalog
    FALLBACK_CATEGORIES = %w[
      brandable shop_brand saas b2b_service local_service media_content
      finance legal health education travel automotive real_estate numeric other
    ].freeze

    class << self
      def categories
        db_codes.presence || FALLBACK_CATEGORIES
      end

      # Locale-aware label for a category code. Falls back to the I18n
      # translation, then to the raw code, so it never returns blank.
      def label_for(code)
        key = code.to_s
        labels_by_code[key] ||
          I18n.t("recommendation_profiles.categories.#{key}", default: key)
      end

      private

      def db_codes
        return [] unless table_available?

        InterestCategory.active.ordered.pluck(:code)
      rescue StandardError
        []
      end

      def labels_by_code
        return {} unless table_available?

        InterestCategory.active.ordered.each_with_object({}) do |category, acc|
          acc[category.code] = category.name
        end
      rescue StandardError
        {}
      end

      def table_available?
        InterestCategory.table_exists?
      rescue StandardError
        false
      end
    end
  end
end
