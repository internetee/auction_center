require 'test_helper'

class InterestCategoryTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def test_enqueues_enrichment_on_create_when_openai_enabled
    with_feature_flag(true) do
      assert_enqueued_with(job: Recommendation::EnrichInterestCategoriesJob) do
        InterestCategory.create!(code: 'newcat', name_en: 'New', name_et: 'Uus')
      end
    end
  end

  def test_does_not_enqueue_enrichment_when_openai_disabled
    with_feature_flag(false) do
      assert_no_enqueued_jobs only: Recommendation::EnrichInterestCategoriesJob do
        InterestCategory.create!(code: 'newcat', name_en: 'New', name_et: 'Uus')
      end
    end
  end

  def test_does_not_re_enqueue_on_unrelated_save
    category = InterestCategory.create!(code: 'newcat', name_en: 'New', name_et: 'Uus')
    category.update_columns(embedding: Array.new(3, 0.1), embedded_at: Time.current)

    with_feature_flag(true) do
      assert_no_enqueued_jobs only: Recommendation::EnrichInterestCategoriesJob do
        category.update!(position: 99)
      end
    end
  end

  def test_requires_code_and_names
    category = InterestCategory.new
    refute category.valid?
    assert category.errors.key?(:code)
    assert category.errors.key?(:name_en)
    assert category.errors.key?(:name_et)
  end

  def test_normalizes_code_to_lowercase
    category = InterestCategory.create!(code: '  SaaS  ', name_en: 'SaaS', name_et: 'SaaS')
    assert_equal 'saas', category.code
  end

  def test_code_uniqueness_is_case_insensitive
    InterestCategory.create!(code: 'saas', name_en: 'SaaS', name_et: 'SaaS')
    dup = InterestCategory.new(code: 'SAAS', name_en: 'Other', name_et: 'Muu')
    refute dup.valid?
  end

  def test_name_is_locale_aware
    category = InterestCategory.new(code: 'health', name_en: 'Health', name_et: 'Tervis')

    I18n.with_locale(:en) { assert_equal 'Health', category.name }
    I18n.with_locale(:et) { assert_equal 'Tervis', category.name }
  end

  def test_name_falls_back_to_english_when_estonian_blank
    category = InterestCategory.new(code: 'health', name_en: 'Health', name_et: '')
    I18n.with_locale(:et) { assert_equal 'Health', category.name }
  end

  def test_seed_defaults_is_idempotent
    InterestCategory.delete_all

    assert_difference -> { InterestCategory.count }, InterestCategory::DEFAULTS.size do
      InterestCategory.seed_defaults!
    end

    assert_no_difference -> { InterestCategory.count } do
      InterestCategory.seed_defaults!
    end
  end

  def test_destroy_purges_orphaned_code_from_profiles_and_classifications
    category = InterestCategory.create!(code: 'temp_cat', name_en: 'Temp', name_et: 'Temp')

    profile = users(:participant).recommendation_profile ||
              RecommendationProfile.create!(user: users(:participant))
    profile.update_columns(interest_keywords: %w[saas temp_cat]) # skip normalize

    classification = DomainClassification.create!(
      domain_name: 'temp-cat-domain.ee',
      classification_source: DomainClassification::OPENAI_SOURCE,
      confidence: 0.9,
      classified_at: 1.hour.ago,
      primary_category: 'temp_cat',
      tags: %w[temp_cat other]
    )

    category.destroy

    assert_equal %w[saas], profile.reload.interest_keywords
    classification.reload
    assert_equal %w[other], classification.tags
    assert_nil classification.primary_category
  end

  def test_seed_defaults_does_not_clobber_admin_edits
    InterestCategory.delete_all
    InterestCategory.seed_defaults!
    InterestCategory.find_by(code: 'saas').update!(name_en: 'Custom SaaS')

    InterestCategory.seed_defaults!

    assert_equal 'Custom SaaS', InterestCategory.find_by(code: 'saas').name_en
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
