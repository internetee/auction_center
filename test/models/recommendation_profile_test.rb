require 'test_helper'

class RecommendationProfileTest < ActiveSupport::TestCase
  def setup
    super
    @profile = RecommendationProfile.new(user: users(:participant))
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
end
