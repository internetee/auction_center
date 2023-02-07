require 'application_system_test_case'

class EditUserTest < ApplicationSystemTestCase
  include SemanticUiHelper

  def setup
    super

    @user = users(:participant)
    sign_in(@user)
  end

  def teardown
    super

    clear_email_deliveries
  end

  def test_edit_form_contains_existing_values
    visit edit_user_path(@user.uuid)

    country_code_field = page.find_field('user[country_code]', visible: false)
    assert_equal(@user.country_code, country_code_field.value)
  end

  def test_update_of_email_requires_confirmation
    visit edit_user_path(@user.uuid)

    fill_in('user[email]', with: 'updated-email@auction.test')
    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')
    assert_text 'Confirmation link was sent to new email address. Please confirm the address for the change to take an effect!'

    last_email = ActionMailer::Base.deliveries.last
    assert_equal('Confirmation instructions', last_email.subject)
    assert_equal(['updated-email@auction.test'], last_email.to)
  end

  def test_update_of_email_requires_providing_existing_password
    visit edit_user_path(@user.uuid)

    fill_in('user[email]', with: 'updated-email@auction.test')
    fill_in('user[current_password]', with: 'not-correct-password')
    click_link_or_button('Update')
    assert(page.has_css?('div.notice', text: 'Incorrect current password'))
  end

  def test_can_change_contact_data
    visit edit_user_path(@user.uuid)
    fill_in('user[email]', with: 'updated-email@auction.test')
    fill_in('user[given_names]', with: 'New Given Name')
    fill_in('user[surname]', with: 'New Surname')
    fill_in('user[mobile_phone]', with: '+3725000600')
    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')

    assert_text 'Confirmation link was sent to new email address. Please confirm the address for the change to take an effect!'

    @user.reload
    assert_equal('New Surname', @user.surname)
  end

  def test_update_adds_updated_by_field
    visit edit_user_path(@user.uuid)
    fill_in('user[given_names]', with: 'New Given Name')
    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')

    assert(page.has_css?('div.notice', text: 'Updated successfully.'))
    @user.reload
    assert_equal('New Given Name', @user.given_names)

    # This is the old name, as it is recorded before the change is made.
    assert_equal("#{@user.id} - Joe John Participant", @user.updated_by)
  end

  def test_terms_and_conditions_are_not_updated_if_already_accepted
    original_terms_and_conditions_accepted_at = @user.terms_and_conditions_accepted_at
    visit edit_user_path(@user.uuid)

    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')

    assert(page.has_css?('div.notice', text: 'Updated successfully.'))

    @user.reload
    assert_equal(original_terms_and_conditions_accepted_at, @user.terms_and_conditions_accepted_at)
  end

  def test_user_cannot_remove_terms_and_conditions_opt_in
    visit edit_user_path(@user.uuid)

    fill_in('user[current_password]', with: 'password123')
    uncheck_checkbox('user[accepts_terms_and_conditions]')
    click_link_or_button('Update')

    assert_not(page.has_css?('div.notice', text: 'Updated successfully.'))
    assert(page.has_text?('Terms and conditions must be accepted'))
  end

  def test_country_can_also_be_changed
    visit edit_user_path(@user.uuid)
    # select_from_dropdown('Poland', from: 'user[country_code]')
    # select_from_dropdown('Poland', from: 'user[country_code]')

    select 'Poland', from: 'user[country_code]'
    # find('.ui.dropdown.selection').click
    find('.ui.dropdown').click
    find('.menu.transition.visible').find('.item', text: 'Poland').click

    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')

    assert(page.has_text?('PL'))
  end

  def test_mobile_phone_needs_to_be_valid
    visit edit_user_path(@user.uuid)
    fill_in('user[mobile_phone]', with: '+37250006000')
    fill_in('user[current_password]', with: 'password123')

    page.find('body').click # blur
    assert(page.has_button?('Update'))
    click_link_or_button('Update')

    assert(page.has_css?('.header.notice', text: 'Updated successfully.'))
    assert(page.has_text?('+37250006000'))
  end

  def test_mobile_phone_is_formatted_according_to_country
    visit edit_user_path(@user.uuid)
    fill_in('user[mobile_phone]', with: '+37250006000')

    fill_in('user[current_password]', with: 'password123')
    assert(page.has_button?('Update'))
    click_link_or_button('Update')

    assert(page.has_css?('div.header.notice', text: 'Updated successfully.'))
    assert(page.has_text?('+37250006000'))
  end

  def test_blank_values_are_ommited
    visit edit_user_path(@user.uuid)

    fill_in('user[surname]', with: '')
    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')

    assert(page.has_css?('div.notice', text: 'Updated successfully.'))

    @user.reload
    assert_equal('Participant', @user.surname)
  end

  def test_administrator_can_also_edit_their_own_data
    administrator = users(:administrator)
    sign_in(administrator)

    visit edit_user_path(administrator.uuid)
    fill_in('user[given_names]', with: 'New Given Name')
    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')

    assert(page.has_css?('div.notice', text: 'Updated successfully.'))
    assert_text('New Given Name')
  end

  def test_profile_page_has_a_link_to_terms_and_conditions
    visit user_path(@user.uuid)
    assert(page.has_link?('Review terms and condition', href: Setting.find_by(code: 'terms_and_conditions_link').retrieve))
  end

  def test_user_was_subscripted_and_unsubscripted_notifications
    @user.update(locale: :en)
    @user.reload
    visit edit_user_path(@user.uuid)

    check_checkbox('user[daily_summary]')
    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')

    assert(page.has_css?('div.notice', text: 'Updated successfully.'))
    assert_text('Yes')

    visit edit_user_path(@user.uuid)
    uncheck_checkbox('user[daily_summary]')
    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')

    assert(page.has_css?('div.notice', text: 'Updated successfully.'))
    assert_text('No')
    @user.update(locale: :et)
    @user.reload
  end

  def test_is_subscripe_checkbox_is_checked_or_not
    visit edit_user_path(@user.uuid)
    checkbox = find(:xpath, '//*[@id="user_daily_summary"]', :visible => false, match: :first)

    assert_not checkbox.checked?

    checkbox.set(true)

    assert checkbox.checked?
  end

  def test_password_user_can_login_with_tara
    @user.update!(identity_code: nil)
    visit edit_user_path(@user.uuid)

    fill_in('user[identity_code]', with: '51007050120')
    fill_in('user[current_password]', with: 'password123')
    click_link_or_button('Update')

    @user.reload

    assert_equal @user.identity_code, '51007050120'

    sign_out(@user)

    omniauth_hash = {
      'provider' => 'tara',
      'uid' => 'EE51007050120',
      'info' => {
        'first_name' => @user.given_names,
        'last_name' => @user.surname,
        'name' => 'EE51007050120',
      },
    }

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:tara] = OmniAuth::AuthHash.new(omniauth_hash)

    visit root_path
    click_link('Sign in')

    within('#tara-sign-in') do
      click_link('Sign in')
    end

    @user.reload

    assert_text('Signed in successfully')
    assert_equal @user.provider, 'tara'
    assert_equal @user.uid, 'EE51007050120'

    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth['tara'] = nil
    clear_email_deliveries
  end
end
