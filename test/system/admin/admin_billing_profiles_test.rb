require 'application_system_test_case'

class AdminBillingProfilesTest < ApplicationSystemTestCase
  def setup
    super

    @administrator = users(:administrator)
    sign_in(@administrator)
  end

  def test_displays_a_list_of_billing_profiles
    visit admin_billing_profiles_path

    names = page.find_all('.billing-profile-name').map(&:text)
    assert_equal(['Joe John Participant', 'ACME Inc.'].to_set, names.to_set)
  end
end
