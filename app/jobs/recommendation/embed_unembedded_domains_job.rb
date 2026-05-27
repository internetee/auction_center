module Recommendation
  # Cron-only job (rake recommendation:embed_unembedded).
  # Picks classified rows that have a description but no embedding,
  # batches them through DomainEmbedder, and persists the vectors.
  class EmbedUnembeddedDomainsJob < ApplicationJob
    MAX_DOMAINS_PER_RUN = 500
    BATCH_SIZE = Recommendation::DomainEmbedder::BATCH_LIMIT

    retry_on StandardError, wait: 30.seconds, attempts: 2

    def perform
      return unless Feature.open_ai_integration_enabled?
      return unless DomainClassification.column_names.include?('embedding')

      rows = self.class.scope.limit(MAX_DOMAINS_PER_RUN).to_a
      return if rows.empty?

      processed = 0
      rows.each_slice(BATCH_SIZE) do |batch|
        results = Recommendation::DomainEmbedder.call(rows: batch)
        processed += persist(results)
      end

      Rails.logger.info("EmbedUnembeddedDomainsJob embedded #{processed} domains")
      processed
    end

    def self.scope
      DomainClassification
        .needs_embedding
        .where.not(description: [nil, ''])
        .order(:classified_at)
    end

    def self.needs_to_run?
      return false unless DomainClassification.column_names.include?('embedding')

      Feature.open_ai_integration_enabled? && scope.exists?
    end

    private

    def persist(results)
      return 0 if results.empty?

      by_name = results.index_by { |r| r[:domain_name] }
      DomainClassification.where(domain_name: by_name.keys).find_each do |record|
        payload = by_name[record.domain_name]
        next unless payload

        record.update_columns(
          embedding: payload[:embedding],
          embedding_model: payload[:embedding_model],
          embedded_at: payload[:embedded_at]
        )
      end
      results.size
    end
  end
end
