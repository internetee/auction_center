require 'application_system_test_case'

class EstonianValidationsTest < ApplicationSystemTestCase
  def setup
    super

    @valid_identity_code = '51007050360'
    @valid_mobile_number = '+3725317763'
    prefill_the_form
  end


  def test_requires_valid_identity_code_for_user_creation
    fill_in('user[identity_code]', with: @valid_identity_code)
    fill_in('user[mobile_phone]', with: @valid_mobile_number)

    assert_difference 'User.count' do
      click_link_or_button('Sign up')
    end
  end

  def test_invalid_phone_number_does_not_create_user
    fill_in('user[identity_code]', with: @valid_identity_code)
    fill_in('user[mobile_phone]', with: '+3727271000')

    assert_no_difference 'User.count' do
      click_link_or_button('Sign up')
    end
  end

  def test_invalid_identity_code_does_not_create_user
    fill_in('user[identity_code]', with: '05071020395')
    fill_in('user[mobile_phone]', with: @valid_mobile_number)

    assert_no_difference 'User.count' do
      click_link_or_button('Sign up')
    end
  end

  def test_validations_are_ignored_for_different_countries
    fill_in('user[identity_code]', with: '05071020395')
    fill_in('user[mobile_phone]', with: '+3715071020395')
    select('Latvia', from: 'user[country_code]')

    assert_difference 'User.count' do
      click_link_or_button('Sign up')
    end
  end

  def prefill_the_form
    visit new_user_path

    fill_in('user[email]', with: 'new-user@auction.test')
    fill_in('user[password]', with: 'password')
    fill_in('user[password_confirmation]', with: 'password')
    fill_in('user[given_names]', with: 'User with Multiple Names')
    fill_in('user[surname]', with: 'Last Name')
    select('Estonia', from: 'user[country_code]')
  end
end
