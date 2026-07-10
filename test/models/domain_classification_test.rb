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

  def test_needs_embedding_picks_rows_without_a_vector
    skip 'embedding column missing' unless DomainClassification.column_names.include?('embedding')

    bare = DomainClassification.create!(domain_name: 'bare-embed.ee', classified_at: 1.hour.ago)
    assert_includes DomainClassification.needs_embedding.to_a, bare
  end

  def test_needs_embedding_picks_rows_built_under_an_older_input_version
    skip 'version column missing' unless DomainClassification.column_names.include?('embedding_input_version')

    # Has a vector but NULL version (every pre-versioning row) — must be re-embedded.
    legacy = DomainClassification.create!(
      domain_name: 'legacy-vec.ee',
      classified_at: 1.hour.ago,
      embedding: Array.new(3, 0.1),
      embedding_input_version: nil
    )
    # Has a vector built under an explicitly older version.
    older = DomainClassification.create!(
      domain_name: 'older-vec.ee',
      classified_at: 1.hour.ago,
      embedding: Array.new(3, 0.1),
      embedding_input_version: Recommendation::DomainEmbedder::INPUT_VERSION - 1
    )

    scope = DomainClassification.needs_embedding.to_a
    assert_includes scope, legacy, 'NULL version must be caught (NULL != current is unknown in SQL)'
    assert_includes scope, older
  end

  def test_needs_embedding_excludes_rows_at_the_current_input_version
    skip 'version column missing' unless DomainClassification.column_names.include?('embedding_input_version')

    current = DomainClassification.create!(
      domain_name: 'current-vec.ee',
      classified_at: 1.hour.ago,
      embedding: Array.new(3, 0.1),
      embedding_input_version: Recommendation::DomainEmbedder::INPUT_VERSION
    )
    refute_includes DomainClassification.needs_embedding.to_a, current
  end

  def test_embedding_reset_attributes_nulls_the_input_version
    skip 'version column missing' unless DomainClassification.column_names.include?('embedding_input_version')

    assert_includes DomainClassification.embedding_reset_attributes.keys, :embedding_input_version
    assert_nil DomainClassification.embedding_reset_attributes[:embedding_input_version]
  end
end
