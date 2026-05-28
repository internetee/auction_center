require 'test_helper'

module Recommendation
  class EmbedUnembeddedDomainsJobTest < ActiveJob::TestCase
    def setup
      super
      DomainClassification.delete_all
    end

    def test_no_op_when_embedding_column_missing
      skip 'embedding column present' if DomainClassification.column_names.include?('embedding')

      assert_nothing_raised do
        Recommendation::EmbedUnembeddedDomainsJob.new.perform
      end
    end

    def test_no_op_when_openai_disabled
      DomainClassification.create!(
        domain_name: 'pending-embed.ee',
        keywords: %w[k1],
        classification_source: DomainClassification::OPENAI_SOURCE,
        classified_at: 1.hour.ago,
        confidence: 0.9
      )

      with_feature_flag(false) do
        assert_nil Recommendation::EmbedUnembeddedDomainsJob.new.perform
      end
    end

    def test_scope_picks_classified_without_embedding
      skip 'embedding column missing' unless DomainClassification.column_names.include?('embedding')

      target = DomainClassification.create!(
        domain_name: 'embed-me.ee',
        keywords: %w[cloud],
        classification_source: DomainClassification::OPENAI_SOURCE,
        classified_at: 1.hour.ago,
        confidence: 0.9
      )

      unclassified = DomainClassification.create!(
        domain_name: 'not-classified.ee',
        classification_source: DomainClassification::HEURISTIC_SOURCE
        # classified_at left nil — not yet classified, should NOT be picked
      )

      ids = Recommendation::EmbedUnembeddedDomainsJob.scope.pluck(:id)
      assert_includes ids, target.id
      refute_includes ids, unclassified.id
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
