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
    assert_equal(['Joe John Participant', 'ACME Inc.', 'Orphan Profile'].to_set, names.to_set)
  end

  def test_billing_profiles_orphans_are_marked_in_table
    visit admin_billing_profiles_path

    within('tbody#billing-profiles-table-body') do
      assert_text('Orphaned')
      assert_text('Orphan Profile')
    end
  end

  def test_billing_profiles_orphans_are_marked_on_view_page
    orphan = billing_profiles(:orphaned)
    visit admin_billing_profile_path(orphan)

    assert_text('Orphaned')
    assert_text('Orphan')
    assert_text('NW1 6XE')
    assert_text('London')
  end
end
