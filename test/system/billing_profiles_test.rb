require 'application_system_test_case'

class BillingProfilesTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:participant)
    sign_in(@user)
  end

  def test_a_user_can_create_billing_profile_for_a_company
    visit new_billing_profile_path
    fill_in_address

    fill_in('billing_profile[name]', with: 'ACME corporation')
    fill_in('billing_profile[vat_code]', with: '1234567890')
    check('billing_profile[legal_entity]')


    assert_changes('BillingProfile.count') do
      click_link_or_button('Submit')
    end

    assert(page.has_css?('div.alert', text: 'Created successfully.'))
  end

  def test_a_user_can_create_private_billing_profile_for_someone_else
    visit new_billing_profile_path
    fill_in_address

    fill_in('billing_profile[name]', with: 'Private Person')
    uncheck('billing_profile[legal_entity]')

    assert_changes('BillingProfile.count') do
      click_link_or_button('Submit')
    end

    assert(page.has_css?('div.alert', text: 'Created successfully.'))
  end

  def test_a_user_can_create_private_billing_profile_for_themselves
    visit new_billing_profile_path
    fill_in_address

    uncheck('billing_profile[legal_entity]')

    assert_changes('BillingProfile.count') do
      click_link_or_button('Submit')
    end

    assert(page.has_css?('div.alert', text: 'Created successfully.'))
    assert(BillingProfile.find_by(name: @user.display_name))
  end

  def fill_in_address
    fill_in('billing_profile[street]', with: 'Baker Street 221B')
    fill_in('billing_profile[city]', with: 'London')
    fill_in('billing_profile[postal_code]', with: 'NW1 6XE')
    fill_in('billing_profile[country]', with: 'United Kingdom')
  end
end
