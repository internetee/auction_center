module Recommendation
  # Runs once per day via a k8s CronJob (rake recommendation:classify_unclassified).
  # Picks domain_classifications rows that need LLM enrichment, batches them,
  # and upserts the enriched attributes.
  #
  # NEVER called from user-facing request paths.
  class ClassifyUnclassifiedDomainsJob < ApplicationJob
    MAX_DOMAINS_PER_RUN = 200
    BATCH_SIZE = Recommendation::LlmDomainClassifier::BATCH_LIMIT

    retry_on StandardError, wait: 30.seconds, attempts: 2

    def perform
      return unless Feature.open_ai_integration_enabled?

      domains = scope.limit(MAX_DOMAINS_PER_RUN).pluck(:domain_name)
      return if domains.empty?

      processed = 0
      domains.each_slice(BATCH_SIZE) do |batch|
        attributes_list = Recommendation::LlmDomainClassifier.call(domain_names: batch)
        processed += upsert(attributes_list)
      end

      Rails.logger.info("ClassifyUnclassifiedDomainsJob processed #{processed} domains")
      processed
    end

    def self.scope
      DomainClassification.needs_llm_enrichment.order(Arel.sql('COALESCE(classified_at, to_timestamp(0)) ASC'))
    end

    def self.needs_to_run?
      Feature.open_ai_integration_enabled? && scope.exists?
    end

    def scope
      self.class.scope
    end

    private

    def upsert(attributes_list)
      return 0 if attributes_list.blank?

      timestamps = { created_at: Time.current, updated_at: Time.current }
      rows = attributes_list.map { |attrs| attrs.merge(timestamps) }

      DomainClassification.upsert_all(rows, unique_by: :domain_name)
      rows.size
    end
  end
end
