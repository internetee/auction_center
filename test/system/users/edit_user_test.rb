require 'application_system_test_case'

class EditUserTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:participant)
    sign_in(@user)
  end

  def test_edit_form_contains_existing_values
    visit edit_user_path(@user)

    country_code_field = page.find_field('user[country_code]')
    assert_equal(@user.country_code, country_code_field.value)
  end

  def test_update_of_email_requires_confirmation
    visit edit_user_path(@user)

    fill_in('user[email]', with: 'updated-email@auction.test')
    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')
    assert(page.has_css?('div.alert', text: 'Updated successfully.'))

    last_email = ActionMailer::Base.deliveries.last
    assert_equal('Confirmation instructions', last_email.subject)
    assert_equal(['updated-email@auction.test'], last_email.to)
  end

  def test_update_of_email_requires_providing_existing_password
    visit edit_user_path(@user)

    fill_in('user[email]', with: 'updated-email@auction.test')
    fill_in('user[current_password]', with: 'not-correct-password')
    click_link_or_button('Update')
    assert(page.has_css?('div.alert', text: 'Incorrect current password'))
    assert(ActionMailer::Base.deliveries.empty?)
  end

  def test_can_change_contact_data
    visit edit_user_path(@user)
    fill_in('user[email]', with: 'updated-email@auction.test')
    fill_in('user[given_names]', with: 'New Given Name')
    fill_in('user[surname]', with: 'New Surname')
    fill_in('user[mobile_phone]', with: '+3725000600')
    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')

    assert(page.has_css?('div.alert', text: 'Updated successfully.'))

    @user.reload
    assert_equal('New Surname', @user.surname)
  end

  def test_terms_and_conditions_are_not_updated_if_already_accepted
    original_terms_and_conditions_accepted_at = @user.terms_and_conditions_accepted_at
    visit edit_user_path(@user)

    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')

    assert(page.has_css?('div.alert', text: 'Updated successfully.'))

    @user.reload
    assert_equal(original_terms_and_conditions_accepted_at, @user.terms_and_conditions_accepted_at)
  end

  def test_user_cannot_remove_terms_and_conditions_opt_in
    visit edit_user_path(@user)

    fill_in('user[current_password]', with: 'password123')
    uncheck('user[accepts_terms_and_conditions]')
    click_link_or_button('Update')

    refute((page.has_css?('div.alert', text: 'Updated successfully.')))
    assert(page.has_text?('Terms and conditions must be accepted'))
  end

  def test_identity_code_and_country_can_also_be_changed
    visit edit_user_path(@user)
    fill_in('user[identity_code]', with: '1234-5678')
    select('Poland', from: 'user[country_code]')
    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')

    assert(page.has_text?('PL'))
    assert(page.has_text?('1234-5678'))
  end

  def test_mobile_phone_needs_to_be_valid
    visit edit_user_path(@user)
    fill_in('user[mobile_phone]', with: '+372 500')
    fill_in('user[current_password]', with: 'password123')
    refute(page.has_button?('Update'))

    fill_in('user[mobile_phone]', with: '+37250006000')
    page.find('body').click # blur
    assert(page.has_button?('Update'))
    click_link_or_button('Update')

    assert(page.has_css?('div.alert', text: 'Updated successfully.'))
    assert(page.has_text?('+37250006000'))
  end

  def test_blank_values_are_ommited
    visit edit_user_path(@user)

    fill_in('user[surname]', with: '')
    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')

    assert(page.has_css?('div.alert', text: 'Updated successfully.'))

    @user.reload
    assert_equal('Participant', @user.surname)
  end

  def test_administrator_can_also_edit_their_own_data
    administrator = users(:administrator)
    sign_in(administrator)

    visit edit_user_path(administrator)
    fill_in('user[given_names]', with: 'New Given Name')
    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')

    assert(page.has_css?('div.alert', text: 'Updated successfully.'))
    assert_text('New Given Name')
  end

  def test_profile_page_has_a_link_to_terms_and_conditions
    visit user_path(@user)
    assert(page.has_link?("Review terms and condition", href: Setting.terms_and_conditions_link))
  end
end
