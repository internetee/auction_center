require 'test_helper'

class BillingProfileTest < ActiveSupport::TestCase
  def test_required_fields
    billing_profile = BillingProfile.new

    refute(billing_profile.valid?)
    assert_equal(["can't be blank"], billing_profile.errors[:user])
    assert_equal(["can't be blank"], billing_profile.errors[:street])
    assert_equal(["can't be blank"], billing_profile.errors[:city])
    assert_equal(["can't be blank"], billing_profile.errors[:postal_index])
    assert_equal(["can't be blank"], billing_profile.errors[:country])
  end
end
