module Recommendation
  # One-shot job that collects every domain name we know about from
  # auctions, wishlist_items, domain_offer_histories, and result records,
  # then classifies the ones without a row via the LLM (batched).
  #
  # The LLM maps each domain onto an InterestCatalog category code. There
  # is no heuristic fallback — if OpenAI is disabled this job is a no-op.
  #
  # Invoked manually or via `rake recommendation:backfill`. One-time cost
  # is ~$1 over a few thousand historical domains.
  class BackfillDomainClassificationsJob < ApplicationJob
    BATCH_SIZE = Recommendation::LlmDomainClassifier::BATCH_LIMIT

    def perform
      return unless Feature.open_ai_integration_enabled?

      domains = collect_domains
      Rails.logger.info("BackfillDomainClassificationsJob found #{domains.size} unique domains")

      already_known = DomainClassification.where(domain_name: domains).pluck(:domain_name).to_set
      pending = domains.reject { |d| already_known.include?(d) }

      Rails.logger.info("BackfillDomainClassificationsJob classifying #{pending.size} new domains")

      classified = 0
      pending.each_slice(BATCH_SIZE) do |slice|
        classified += upsert(Recommendation::LlmDomainClassifier.call(domain_names: slice))
      rescue StandardError => e
        Rails.logger.warn("Backfill batch failed (#{slice.first}..): #{e.message}")
      end

      Rails.logger.info("BackfillDomainClassificationsJob created #{classified} classifications")
      classified
    end

    private

    def upsert(attributes_list)
      return 0 if attributes_list.blank?

      timestamps = { created_at: Time.current, updated_at: Time.current }
      rows = attributes_list.map { |attrs| attrs.merge(timestamps) }
      DomainClassification.upsert_all(rows, unique_by: :domain_name)
      rows.size
    end

    def collect_domains
      sources = [
        Auction.distinct.pluck(:domain_name),
        WishlistItem.distinct.pluck(:domain_name),
        safe_pluck('DomainOfferHistory', :domain_name),
        safe_pluck('Result', :domain_name)
      ]

      sources.flatten
             .map { |d| d.to_s.strip.downcase }
             .reject(&:blank?)
             .uniq
    end

    # Resolve the model by name so an absent constant (e.g. DomainOfferHistory
    # is not defined in this codebase) degrades to [] instead of raising
    # NameError when the argument is evaluated.
    def safe_pluck(model_name, column)
      return [] unless Object.const_defined?(model_name)

      model = Object.const_get(model_name)
      return [] unless model.respond_to?(:column_names) && model.column_names.include?(column.to_s)

      model.distinct.pluck(column)
    rescue StandardError => e
      Rails.logger.warn("Backfill source #{model_name} failed: #{e.message}")
      []
    end
  end
end
