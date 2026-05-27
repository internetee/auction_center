require 'test_helper'

module Recommendation
  class DomainClassifierTest < ActiveSupport::TestCase
    def test_creates_classification_for_unseen_domain
      assert_difference -> { DomainClassification.count }, 1 do
        Recommendation::DomainClassifier.call('kohvik.ee')
      end

      record = DomainClassification.find_by(domain_name: 'kohvik.ee')
      assert_equal 'local_service', record.primary_category
      assert_equal DomainClassification::HEURISTIC_SOURCE, record.classification_source
    end

    def test_returns_existing_record_when_fresh
      Recommendation::DomainClassifier.call('cloudstack.ee')

      assert_no_difference -> { DomainClassification.count } do
        Recommendation::DomainClassifier.call('cloudstack.ee')
      end
    end

    def test_force_recomputes_even_when_fresh
      Recommendation::DomainClassifier.call('apteek.ee')
      record = DomainClassification.find_by(domain_name: 'apteek.ee')
      record.update_columns(classified_at: 10.seconds.ago)

      Recommendation::DomainClassifier.call('apteek.ee', force: true)
      record.reload
      assert record.classified_at > 1.second.ago
    end

    def test_preserves_llm_enriched_fields_when_running_heuristic_again
      record = DomainClassification.create!(
        domain_name: 'rich.ee',
        primary_category: 'saas',
        tags: %w[saas b2b_service],
        description: 'Description by LLM',
        description_locale: 'en',
        audience: 'b2b',
        languages: %w[en],
        suggested_use_cases: %w[agency],
        brandability_score: 0.9,
        confidence: 0.92,
        classification_source: DomainClassification::OPENAI_SOURCE,
        classification_model: 'gpt-5',
        classified_at: 2.hours.ago
      )

      Recommendation::DomainClassifier.call('rich.ee', force: true)
      record.reload

      assert_equal 'Description by LLM', record.description
      assert_equal DomainClassification::OPENAI_SOURCE, record.classification_source
      assert_equal 'saas', record.primary_category
    end

    def test_no_op_for_blank_domain
      assert_nil Recommendation::DomainClassifier.call('')
      assert_nil Recommendation::DomainClassifier.call(nil)
    end

    def test_lowercases_input
      Recommendation::DomainClassifier.call('  KOHVIK.EE  ')
      assert DomainClassification.exists?(domain_name: 'kohvik.ee')
    end
  end
end
