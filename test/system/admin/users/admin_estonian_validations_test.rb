require 'application_system_test_case'

class AdminEstonianValidationsTest < ApplicationSystemTestCase
  def setup
    super

    @valid_identity_code = '51007050360'
    @valid_mobile_number = '+372 5517 7631'
    prefill_the_form
  end


  def test_requires_valid_identity_code_for_user_creation
    fill_in('user[identity_code]', with: @valid_identity_code)
    fill_in('user[mobile_phone]', with: @valid_mobile_number)
    page.find('body').click # blur

    assert_difference 'User.count' do
      click_link_or_button('Submit')
    end
  end

  def test_invalid_phone_number_disables_submit_button
    fill_in('user[identity_code]', with: @valid_identity_code)
    fill_in('user[mobile_phone]', with: '+372 11111111111111111111111117 1000')
    page.find('body').click # blur

    refute(page.has_button?('Submit'))
  end

  def test_invalid_identity_code_disables_submit_button
    fill_in('user[identity_code]', with: '8923789')
    fill_in('user[mobile_phone]', with: @valid_mobile_number)
    page.find('body').click # blur

    refute(page.has_button?('Submit'))
  end

  def test_identity_code_validations_are_ignored_for_different_countries
    fill_in('user[identity_code]', with: '05071020395')
    fill_in('user[mobile_phone]', with: '+371 2 63 12345')
    select('Latvia', from: 'user[country_code]')

    assert_difference 'User.count' do
      click_link_or_button('Submit')
    end
  end

  def prefill_the_form
    sign_in users(:administrator)
    visit new_admin_user_path
    fill_in('user[email]', with: 'new-user@auction.test')
    fill_in('user[password]', with: 'password')
    fill_in('user[password_confirmation]', with: 'password')
    fill_in('user[given_names]', with: 'User with Multiple Names')
    fill_in('user[surname]', with: 'Last Name')
    check('user[accepts_terms_and_conditions]')
    select('Estonia', from: 'user[country_code]')
  end
end
