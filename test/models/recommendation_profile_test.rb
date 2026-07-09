require 'test_helper'

class RecommendationProfileTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def setup
    super
    @profile = RecommendationProfile.new(user: users(:participant))
  end

  def test_custom_interest_change_enqueues_embedding_when_openai_enabled
    with_feature_flag(true) do
      assert_enqueued_with(job: Recommendation::EmbedCustomInterestsJob) do
        @profile.custom_interests = ['crypto']
        @profile.save!
      end
    end
  end

  def test_category_only_change_does_not_enqueue_embedding
    with_feature_flag(false) do
      @profile.interest_categories = %w[saas]
      @profile.save!
    end

    with_feature_flag(true) do
      assert_no_enqueued_jobs only: Recommendation::EmbedCustomInterestsJob do
        @profile.interest_categories = %w[saas finance]
        @profile.save!
      end
    end
  end

  def test_no_embedding_enqueued_when_openai_disabled
    with_feature_flag(false) do
      assert_no_enqueued_jobs only: Recommendation::EmbedCustomInterestsJob do
        @profile.custom_interests = ['crypto']
        @profile.save!
      end
    end
  end

  def test_promptable_until_completed
    assert @profile.promptable?

    @profile.completed_at = Time.current
    refute @profile.promptable?
  end

  def test_promptable_again_after_dismiss_interval
    @profile.prompt_dismissed_at = 1.day.ago
    refute @profile.promptable?

    @profile.prompt_dismissed_at = 20.days.ago
    assert @profile.promptable?
  end

  def test_normalizes_interest_categories
    @profile.interest_categories = %w[saas legal saas numeric]
    @profile.valid?

    assert_equal(%w[saas legal numeric], @profile.interest_categories)
  end

  def test_stores_custom_interests_under_other
    @profile.custom_interests = ['marketplace', 'marketplace', 'premium names']
    @profile.valid?

    assert_equal(['other'], @profile.interest_categories)
    assert_equal(['marketplace', 'premium names'], @profile.custom_interests)
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
