module Recommendation
  # One-shot job that collects every domain name we know about from
  # auctions, wishlist_items, domain_offer_histories, and result records,
  # then ensures each has a heuristic classification row.
  #
  # Tier 2 (LLM) enrichment happens on the next nightly run of
  # ClassifyUnclassifiedDomainsJob — this job DOES NOT call the LLM.
  #
  # Invoked manually or via `rake recommendation:backfill`.
  class BackfillDomainClassificationsJob < ApplicationJob
    BATCH_SIZE = 500

    def perform
      domains = collect_domains
      Rails.logger.info("BackfillDomainClassificationsJob found #{domains.size} unique domains")

      already_known = DomainClassification.where(domain_name: domains).pluck(:domain_name).to_set
      pending = domains.reject { |d| already_known.include?(d) }

      Rails.logger.info("BackfillDomainClassificationsJob classifying #{pending.size} new domains")

      created = 0
      pending.each_slice(BATCH_SIZE) do |slice|
        slice.each do |domain|
          Recommendation::DomainClassifier.call(domain)
          created += 1
        rescue StandardError => e
          Rails.logger.warn("Backfill failed for #{domain}: #{e.message}")
        end
      end

      Rails.logger.info("BackfillDomainClassificationsJob created #{created} classifications")
      created
    end

    private

    def collect_domains
      sources = [
        Auction.distinct.pluck(:domain_name),
        WishlistItem.distinct.pluck(:domain_name),
        safe_pluck(DomainOfferHistory, :domain_name),
        safe_pluck(Result, :domain_name)
      ]

      sources.flatten
             .map { |d| d.to_s.strip.downcase }
             .reject(&:blank?)
             .uniq
    end

    def safe_pluck(model, column)
      return [] unless defined?(model) && model.respond_to?(:column_names)
      return [] unless model.column_names.include?(column.to_s)

      model.distinct.pluck(column)
    rescue StandardError => e
      Rails.logger.warn("Backfill source #{model} failed: #{e.message}")
      []
    end
  end
end
