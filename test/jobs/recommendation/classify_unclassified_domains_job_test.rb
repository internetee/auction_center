require 'test_helper'

module Recommendation
  class ClassifyUnclassifiedDomainsJobTest < ActiveJob::TestCase
    def setup
      super
      DomainClassification.delete_all
    end

    def test_no_op_when_openai_integration_disabled
      DomainClassification.create!(domain_name: 'pending.ee',
                                   classification_source: DomainClassification::OPENAI_SOURCE,
                                   classified_at: Time.current,
                                   confidence: 0.3)

      with_feature_flag(false) do
        assert_nil Recommendation::ClassifyUnclassifiedDomainsJob.new.perform
      end
    end

    def test_no_op_when_nothing_pending
      with_feature_flag(true) do
        with_missing_domains([]) do
          assert_nil Recommendation::ClassifyUnclassifiedDomainsJob.new.perform
        end
      end
    end

    def test_reclassifies_low_confidence_existing_row
      DomainClassification.create!(domain_name: 'weak.ee',
                                   classification_source: DomainClassification::OPENAI_SOURCE,
                                   confidence: 0.3,
                                   classified_at: 1.day.ago)

      with_feature_flag(true) do
        with_missing_domains([]) do
          stub_llm do
            processed = Recommendation::ClassifyUnclassifiedDomainsJob.new.perform
            assert_equal 1, processed
          end
        end
      end
    end

    def test_classifies_missing_domains
      with_feature_flag(true) do
        with_missing_domains(['fresh-domain.ee']) do
          stub_llm do
            Recommendation::ClassifyUnclassifiedDomainsJob.new.perform
          end
        end
      end

      assert DomainClassification.exists?(domain_name: 'fresh-domain.ee')
    end

    def test_scope_picks_low_confidence_and_stale_llm_rows
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
      assert_includes scope_ids, low_conf_row.id
      assert_includes scope_ids, stale_row.id
      refute_includes scope_ids, fresh_llm.id
    end

    def test_needs_to_run_reflects_feature_and_work
      with_feature_flag(false) do
        refute Recommendation::ClassifyUnclassifiedDomainsJob.needs_to_run?
      end

      DomainClassification.create!(
        domain_name: 'pending.ee',
        classification_source: DomainClassification::OPENAI_SOURCE,
        confidence: 0.3,
        classified_at: Time.current
      )

      with_feature_flag(true) do
        assert Recommendation::ClassifyUnclassifiedDomainsJob.needs_to_run?
      end
    end

    private

    def stub_llm
      original = Recommendation::LlmDomainClassifier.method(:call)
      Recommendation::LlmDomainClassifier.define_singleton_method(:call) do |domain_names:, **|
        Array(domain_names).map do |d|
          {
            domain_name: d.to_s.strip.downcase,
            primary_category: 'other',
            tags: ['other'],
            keywords: [],
            audience: nil,
            languages: [],
            suggested_use_cases: [],
            brandability_score: nil,
            confidence: 0.9,
            classification_source: DomainClassification::OPENAI_SOURCE,
            classification_model: 'gpt-5',
            classified_at: Time.current,
            raw_llm_response: {}
          }
        end
      end
      yield
    ensure
      Recommendation::LlmDomainClassifier.define_singleton_method(:call, original)
    end

    def with_missing_domains(list)
      original = Recommendation::ClassifyUnclassifiedDomainsJob.method(:missing_domains)
      Recommendation::ClassifyUnclassifiedDomainsJob.define_singleton_method(:missing_domains) { list }
      yield
    ensure
      Recommendation::ClassifyUnclassifiedDomainsJob.define_singleton_method(:missing_domains, original)
    end

    def with_feature_flag(enabled)
      original = Feature.method(:open_ai_integration_enabled?)
      Feature.define_singleton_method(:open_ai_integration_enabled?) { enabled }
      yield
    ensure
      Feature.define_singleton_method(:open_ai_integration_enabled?, original)
    end
  end
end
