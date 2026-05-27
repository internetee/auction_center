require 'test_helper'

class DomainClassificationTest < ActiveSupport::TestCase
  def test_domain_name_is_required
    record = DomainClassification.new
    refute record.valid?
    assert_includes record.errors[:domain_name], "can't be blank"
  end

  def test_domain_name_is_normalized_to_lowercase_stripped
    record = DomainClassification.create!(domain_name: '  KohViK.ee  ')
    assert_equal 'kohvik.ee', record.domain_name
  end

  def test_domain_name_is_unique
    DomainClassification.create!(domain_name: 'unique.ee')
    duplicate = DomainClassification.new(domain_name: 'unique.ee')
    refute duplicate.valid?
  end

  def test_needs_llm_enrichment_scope_picks_heuristic_rows
    heuristic_row = DomainClassification.create!(
      domain_name: 'fresh-heur.ee',
      classification_source: DomainClassification::HEURISTIC_SOURCE,
      confidence: 0.8,
      classified_at: Time.current
    )
    DomainClassification.create!(
      domain_name: 'fresh-llm.ee',
      classification_source: DomainClassification::OPENAI_SOURCE,
      confidence: 0.95,
      classified_at: 1.day.ago
    )

    assert_includes DomainClassification.needs_llm_enrichment.to_a, heuristic_row
  end

  def test_needs_llm_enrichment_picks_low_confidence_rows
    weak = DomainClassification.create!(
      domain_name: 'weak.ee',
      classification_source: DomainClassification::OPENAI_SOURCE,
      confidence: 0.3,
      classified_at: 1.day.ago
    )
    assert_includes DomainClassification.needs_llm_enrichment.to_a, weak
  end

  def test_needs_llm_enrichment_picks_stale_llm_rows
    stale = DomainClassification.create!(
      domain_name: 'stale.ee',
      classification_source: DomainClassification::OPENAI_SOURCE,
      confidence: 0.95,
      classified_at: 9.months.ago
    )
    assert_includes DomainClassification.needs_llm_enrichment.to_a, stale
  end

  # needs_embedding scope is covered in Phase 5 test suite once the
  # embedding column is added by the pgvector migration.
end
