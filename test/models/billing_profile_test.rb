require 'test_helper'

class BillingProfileTest < ActiveSupport::TestCase
  def setup
    super

    @user = users(:participant)
    @billing_profile = billing_profiles(:company)
    @orphaned_profile = billing_profiles(:orphaned)
  end

  def test_required_fields
    billing_profile = BillingProfile.new

    refute(billing_profile.valid?)
    assert_equal(["can't be blank"], billing_profile.errors[:street])
    assert_equal(["can't be blank"], billing_profile.errors[:city])
    assert_equal(["can't be blank"], billing_profile.errors[:postal_code])
    assert_equal(["can't be blank"], billing_profile.errors[:country_code])
    assert_equal(["can't be blank"], billing_profile.errors[:name])

    billing_profile.name = "Private Person"
    billing_profile.street = "Baker Street 221B"
    billing_profile.city = "London"
    billing_profile.postal_code = "NW1 6XE"
    billing_profile.country_code = "GB"
    assert(billing_profile.valid?)
  end

  def test_vat_codes_must_be_unique_per_user
    duplicate = @billing_profile.dup

    refute(duplicate.valid?)
    assert_equal(duplicate.errors[:vat_code], ['has already been taken'])

    private_person_profile = billing_profiles(:private_person)

    duplicate = private_person_profile.dup
    assert(duplicate.valid?)
  end

  def test_address
    expected_address = 'Baker Street 221B, NW1 6XE London, United Kingdom'

    assert_equal(expected_address, @billing_profile.address)
  end

  def test_user_name
    expected_username = 'Joe John Participant'

    assert_equal(expected_username, @billing_profile.user_name)
    assert_equal('Orphaned', @orphaned_profile.user_name)
  end

  def test_can_be_orphaned_by_a_user
    @user.destroy

    assert_nil(@billing_profile.user)
    assert_equal('Orphaned', @billing_profile.user_name)
  end
end
