require 'application_system_test_case'

class BillingProfilesTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:participant)
    @billing_profile = billing_profiles(:private_person)
    @company_billing_profile = billing_profiles(:company)
    sign_in(@user)
  end

  def test_user_details_contains_a_link_to_billing
    visit user_path(@user)
    assert(page.has_link?('Billing', href: billing_profiles_path))
  end

  def test_administrator_can_only_see_their_own_billing_profiles
    sign_in users(:administrator)
    visit billing_profiles_path

    refute(page.has_link?('ACME Inc.'))
  end

  def test_index_contains_a_link_to_new_billing_profile
    visit billing_profiles_path
    assert(page.has_link?('New', href: new_billing_profile_path))
  end

  def test_billing_profiles_list_contains_links_to_profiles
    visit billing_profiles_path
    assert(page.has_link?('Joe John Participant',
                          href: billing_profile_path(@billing_profile)))
  end

  def test_a_user_can_create_billing_profile_for_a_vat_liable_company
    visit new_billing_profile_path
    fill_in_address

    fill_in('billing_profile[name]', with: 'ACME corporation')
    fill_in('billing_profile[vat_code]', with: '1234567890')

    assert_changes('BillingProfile.count') do
      click_link_or_button('Submit')
    end

    assert(page.has_css?('div.alert', text: 'Created successfully.'))
  end

  def test_billing_profile_vat_code_needs_to_be_unique_for_user
    visit new_billing_profile_path
    fill_in_address

    fill_in('billing_profile[name]', with: @company_billing_profile.name)
    fill_in('billing_profile[vat_code]', with: @company_billing_profile.vat_code)

    assert_no_changes('BillingProfile.count') do
      click_link_or_button('Submit')
    end

    assert(page.has_text?('Vat code has already been taken'))
  end

  def test_a_user_can_create_company_billing_profile_witout_vat_code
    visit new_billing_profile_path
    fill_in_address

    fill_in('billing_profile[name]', with: 'ACME corporation')

    assert_changes('BillingProfile.count') do
      click_link_or_button('Submit')
    end

    assert(page.has_css?('div.alert', text: 'Created successfully.'))
  end

  def test_a_user_can_create_private_billing_profile
    visit new_billing_profile_path
    fill_in_address
     fill_in('billing_profile[name]', with: 'Private Person')

    assert_changes('BillingProfile.count') do
      click_link_or_button('Submit')
    end

    assert(page.has_css?('div.alert', text: 'Created successfully.'))
    assert(BillingProfile.find_by(name: @user.display_name))
  end

  def test_a_user_can_edit_their_billing_profile
    visit billing_profile_path(@billing_profile)
    click_link_or_button('Edit')

    fill_in('billing_profile[street]', with: 'New Street 12')
    fill_in('billing_profile[name]', with: 'Joe John Participant-New')

    assert_no_changes('BillingProfile.count') do
      click_link_or_button('Submit')
    end

    assert(page.has_css?('div.alert', text: 'Updated successfully.'))
    assert(BillingProfile.find_by(street: 'New Street 12', name: 'Joe John Participant-New'))
  end

  def test_a_user_can_delete_their_billing_profile
    visit billing_profile_path(@billing_profile)

    accept_confirm do
      click_link_or_button('Delete')
    end

    assert_text('Deleted successfully.')
  end


  def fill_in_address
    fill_in('billing_profile[street]', with: 'Baker Street 221B')
    fill_in('billing_profile[city]', with: 'London')
    fill_in('billing_profile[postal_code]', with: 'NW1 6XE')
    fill_in('billing_profile[country]', with: 'United Kingdom')
  end
end
