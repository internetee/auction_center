require 'test_helper'

module Recommendation
  class EmbedUnembeddedDomainsJobTest < ActiveJob::TestCase
    def setup
      super
      DomainClassification.delete_all
    end

    def test_no_op_without_embedding_column
      # If pgvector migration has not run yet, the column is absent
      # and the job should bail out cleanly.
      skip 'embedding column present' if DomainClassification.column_names.include?('embedding')

      assert_nothing_raised do
        Recommendation::EmbedUnembeddedDomainsJob.new.perform
      end
    end

    def test_no_op_when_openai_disabled
      DomainClassification.create!(
        domain_name: 'pending-embed.ee',
        description: 'desc',
        keywords: %w[k1],
        classification_source: DomainClassification::OPENAI_SOURCE,
        classified_at: 1.hour.ago,
        confidence: 0.9
      )

      with_feature_flag(false) do
        assert_nil Recommendation::EmbedUnembeddedDomainsJob.new.perform
      end
    end

    def test_scope_skips_rows_without_description
      no_description = DomainClassification.create!(
        domain_name: 'no-desc.ee',
        classification_source: DomainClassification::HEURISTIC_SOURCE,
        classified_at: 1.hour.ago,
        confidence: 0.4
      )

      with_description = DomainClassification.create!(
        domain_name: 'has-desc.ee',
        description: 'has description',
        classification_source: DomainClassification::OPENAI_SOURCE,
        classified_at: 1.hour.ago,
        confidence: 0.9
      )

      scope_ids = Recommendation::EmbedUnembeddedDomainsJob.scope.pluck(:id)
      refute_includes scope_ids, no_description.id
      assert_includes scope_ids, with_description.id if DomainClassification.column_names.include?('embedding')
    end

    private

    def with_feature_flag(enabled)
      original = Feature.method(:open_ai_integration_enabled?)
      Feature.define_singleton_method(:open_ai_integration_enabled?) { enabled }
      yield
    ensure
      Feature.define_singleton_method(:open_ai_integration_enabled?, original)
    end
  end
end
