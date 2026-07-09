module Recommendation
  # Enriches interest categories (LLM description + keywords) and embeds them
  # into the same 1536-dim space as domains, so a selected category can act as
  # a magnet in the v3 unified scorer.
  #
  # Two entry points:
  #   - perform_later(category_id) — reactive, from InterestCategory after_save
  #     when an admin adds/edits a category.
  #   - perform_now              — batch, from PipelineRunner: enriches every
  #     category still missing an embedding.
  class EnrichInterestCategoriesJob < ApplicationJob
    BATCH_SIZE = Recommendation::InterestCategoryEnricher::BATCH_LIMIT

    retry_on StandardError, wait: 30.seconds, attempts: 2

    def perform(category_id = nil)
      return unless Feature.open_ai_integration_enabled?
      return unless InterestCategory.column_names.include?('embedding')

      categories = category_id ? Array(InterestCategory.find_by(id: category_id)) : self.class.scope.to_a
      categories.reject! { |c| c.code.to_s.blank? }
      return if categories.empty?

      processed = 0
      categories.each_slice(BATCH_SIZE) do |batch|
        results = Recommendation::InterestCategoryEnricher.call(categories: batch)
        processed += persist(results)
      end

      Rails.logger.info("EnrichInterestCategoriesJob enriched #{processed} categories")
      processed
    end

    # Active categories that have never been embedded (fresh) or whose keywords
    # are still empty — i.e. everything the enrichment hasn't produced yet.
    def self.scope
      InterestCategory.active.where(embedded_at: nil)
    end

    def self.needs_to_run?
      return false unless InterestCategory.column_names.include?('embedding')

      Feature.open_ai_integration_enabled? && scope.exists?
    end

    private

    def persist(results)
      return 0 if results.empty?

      by_code = results.index_by { |r| r[:code] }
      InterestCategory.where(code: by_code.keys).find_each do |record|
        payload = by_code[record.code]
        next unless payload

        record.update_columns(
          description: payload[:description],
          keywords: payload[:keywords],
          embedding: payload[:embedding],
          embedding_model: payload[:embedding_model],
          embedded_at: payload[:embedded_at]
        )
      end
      results.size
    end
  end
end
