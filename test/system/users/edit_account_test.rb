require 'application_system_test_case'

class EditAccountTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:user)
    sign_in(@user)
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
    fill_in('user[mobile_phone]', with: '+372500110300')
    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')

    assert(page.has_css?('div.alert', text: 'Updated successfully.'))

    @user.reload
    assert_equal('New Surname', @user.surname)
  end

  def test_mobile_phone_needs_to_be_valid
    visit edit_user_path(@user)
    fill_in('user[mobile_phone]', with: '+372500')
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
    assert_equal('User', @user.surname)
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
end
