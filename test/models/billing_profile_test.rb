require 'test_helper'

class BillingProfileTest < ActiveSupport::TestCase
  def setup
    super

    @user = users(:participant)
  end

  def test_required_fields
    billing_profile = BillingProfile.new

    refute(billing_profile.valid?)
    assert_equal(["must exist"], billing_profile.errors[:user])

    assert_equal(["can't be blank"], billing_profile.errors[:street])
    assert_equal(["can't be blank"], billing_profile.errors[:city])
    assert_equal(["can't be blank"], billing_profile.errors[:postal_index])
    assert_equal(["can't be blank"], billing_profile.errors[:country])

    billing_profile.user = @user
    billing_profile.street = "Baker Street 221B"
    billing_profile.city = "London"
    billing_profile.postal_index = "NW1 6XE"
    billing_profile.country = "United Kingdom"
    assert(billing_profile.valid?)
  end
end
