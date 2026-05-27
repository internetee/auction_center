require 'test_helper'

module Recommendation
  class ClassifyUnclassifiedDomainsJobTest < ActiveJob::TestCase
    def setup
      super
      DomainClassification.delete_all
    end

    def test_no_op_when_openai_integration_disabled
      DomainClassification.create!(domain_name: 'pending.ee',
                                   classification_source: DomainClassification::HEURISTIC_SOURCE,
                                   classified_at: Time.current,
                                   confidence: 0.3)

      with_feature_flag(false) do
        result = Recommendation::ClassifyUnclassifiedDomainsJob.new.perform
        assert_nil result
      end
    end

    def test_no_op_when_no_pending_rows
      with_feature_flag(true) do
        result = Recommendation::ClassifyUnclassifiedDomainsJob.new.perform
        assert_nil result
      end
    end

    def test_scope_picks_heuristic_low_confidence_and_stale_llm_rows
      heuristic_row = DomainClassification.create!(
        domain_name: 'h.ee',
        classification_source: DomainClassification::HEURISTIC_SOURCE,
        confidence: 0.9,
        classified_at: 1.day.ago
      )

      low_conf_row = DomainClassification.create!(
        domain_name: 'l.ee',
        classification_source: DomainClassification::OPENAI_SOURCE,
        confidence: 0.3,
        classified_at: 1.day.ago
      )

      stale_row = DomainClassification.create!(
        domain_name: 's.ee',
        classification_source: DomainClassification::OPENAI_SOURCE,
        confidence: 0.95,
        classified_at: 9.months.ago
      )

      fresh_llm = DomainClassification.create!(
        domain_name: 'f.ee',
        classification_source: DomainClassification::OPENAI_SOURCE,
        confidence: 0.95,
        classified_at: 1.day.ago
      )

      scope_ids = Recommendation::ClassifyUnclassifiedDomainsJob.scope.pluck(:id)
      assert_includes scope_ids, heuristic_row.id
      assert_includes scope_ids, low_conf_row.id
      assert_includes scope_ids, stale_row.id
      refute_includes scope_ids, fresh_llm.id
    end

    def test_needs_to_run_reflects_feature_and_scope
      with_feature_flag(false) do
        refute Recommendation::ClassifyUnclassifiedDomainsJob.needs_to_run?
      end

      DomainClassification.create!(
        domain_name: 'pending.ee',
        classification_source: DomainClassification::HEURISTIC_SOURCE,
        confidence: 0.3,
        classified_at: Time.current
      )

      with_feature_flag(true) do
        assert Recommendation::ClassifyUnclassifiedDomainsJob.needs_to_run?
      end
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
