module Recommendation
  # Runs once per day via a k8s CronJob (rake recommendation:classify_unclassified).
  #
  # Safety-net + maintenance pass for the LLM classifier:
  #  - discovers active-auction / wishlist domains that have NO classification
  #    row yet (e.g. ClassifyDomainJob never ran because OpenAI was disabled
  #    when the domain appeared, or the job failed), and
  #  - re-classifies existing rows that are low-confidence or stale (>6mo).
  #
  # Batches everything through the LLM. NEVER called from request paths.
  class ClassifyUnclassifiedDomainsJob < ApplicationJob
    MAX_DOMAINS_PER_RUN = 200
    BATCH_SIZE = Recommendation::LlmDomainClassifier::BATCH_LIMIT

    retry_on StandardError, wait: 30.seconds, attempts: 2

    def perform
      return unless Feature.open_ai_integration_enabled?

      domains = pending_domains
      return if domains.empty?

      processed = 0
      domains.each_slice(BATCH_SIZE) do |batch|
        attributes_list = Recommendation::LlmDomainClassifier.call(domain_names: batch)
        processed += upsert(attributes_list)
      end

      Rails.logger.info("ClassifyUnclassifiedDomainsJob processed #{processed} domains")
      processed
    end

    # Existing rows that need re-classification (low confidence / stale LLM).
    def self.scope
      DomainClassification.needs_llm_enrichment.order(Arel.sql('COALESCE(classified_at, to_timestamp(0)) ASC'))
    end

    # Active-auction / wishlist domains with no classification row at all.
    def self.missing_domains
      known = DomainClassification.pluck(:domain_name).to_set
      candidates = (Auction.active.distinct.pluck(:domain_name) +
                    WishlistItem.distinct.pluck(:domain_name))
                   .map { |d| d.to_s.strip.downcase }
                   .reject(&:blank?)
                   .uniq
      candidates.reject { |d| known.include?(d) }
    end

    def self.needs_to_run?
      return false unless Feature.open_ai_integration_enabled?

      scope.exists? || missing_domains.any?
    end

    private

    def pending_domains
      (self.class.missing_domains + self.class.scope.pluck(:domain_name))
        .uniq
        .first(MAX_DOMAINS_PER_RUN)
    end

    def upsert(attributes_list)
      return 0 if attributes_list.blank?

      timestamps = { created_at: Time.current, updated_at: Time.current }
      rows = attributes_list.map { |attrs| attrs.merge(timestamps) }

      DomainClassification.upsert_all(rows, unique_by: :domain_name)
      rows.size
    end
  end
end
