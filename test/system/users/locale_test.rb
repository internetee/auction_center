require 'application_system_test_case'

class LocaleTest < ApplicationSystemTestCase
  def setup
    super
  end

  def teardown
    super
  end

  def test_anonymous_user_can_change_locale
    visit root_path

    assert(page.has_link?('Eesti keeles'))

    click_link('Eesti keeles')
    assert_text('Oksjonil olevad domeenid')
    assert_not(page.has_link?('Eesti keeles'))
  end

  def test_locale_are_carried_over_on_user_creation
    visit new_user_path
    click_link('Eesti keeles')

    fill_in('user[email]', with: 'new-user@auction.test')
    fill_in('user[password]', with: 'password')
    fill_in('user[password_confirmation]', with: 'password')
    fill_in('user[given_names]', with: 'User with Multiple Names')
    fill_in('user[mobile_phone]', with: '+48600100200')
    select_from_dropdown('Poland', from: 'user[country_code]')
    check_checkbox('user[accepts_terms_and_conditions]')

    fill_in('user[surname]', with: 'Last Name')
    click_link_or_button('Registreeru')

    user = User.find_by(email: 'new-user@auction.test')
    assert_equal('et', user.locale)
  end

  def test_registered_user_can_change_their_locale
    @user = users(:participant)
    sign_in(@user)

    visit root_path
    click_link('Eesti keeles')
    assert_text('Oksjonil olevad domeenid')
    @user.reload

    assert_equal('et', @user.locale)
  end
end
