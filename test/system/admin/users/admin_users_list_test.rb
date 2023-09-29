require 'application_system_test_case'

class AdminUsersListTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:administrator)
    sign_in(@user)
    visit admin_users_path
  end

  def teardown
    super

    clear_email_deliveries
  end

  def test_user_display_names_are_links
    edited_user = users(:participant)
    display_name_cell_link = page.find('a', text: 'Joe John Participant')
    display_name_cell_link.click

    assert_current_path(admin_user_path(edited_user))
  end

  def test_can_create_new_user_accounts
    click_link('New user')

    fill_in('user[email]', with: 'new-user@auction.test')
    fill_in('user[password]', with: 'password123')
    fill_in('user[password_confirmation]', with: 'password123')
    fill_in('user[given_names]', with: 'User with Multiple Names')
    fill_in('user[mobile_phone]', with: '+48600100200')
    
    # select_from_dropdown('Poland', from: 'user[country_code]')
    select 'Poland', from: 'user[country_code]'

    fill_in('user[surname]', with: 'Last Name')
    check_checkbox('user[accepts_terms_and_conditions]')
    check_checkbox('user_roles_administrator')

    click_link_or_button('Submit')

    assert_text('Created successfully')
    last_email = ActionMailer::Base.deliveries.last
    assert_equal('Confirmation instructions', last_email.subject)
    assert_equal(['new-user@auction.test'], last_email.to)
  end

  def test_form_has_terms_and_conditions_link
    visit new_admin_user_path
    assert(page.has_link?('auction portal user agreement', href: Setting.find_by(code: 'terms_and_conditions_link').retrieve))
  end

  def test_certain_fields_are_required
    click_link('New user')
    fill_in('user[mobile_phone]', with: '+48600100200')

    click_link_or_button('Submit')

    errors_list = page.find('#errors').all('li')
    assert_equal(7, errors_list.size)
    errors_array = errors_list.collect(&:text)

    expected_errors = ["Email can't be blank", "Password can't be blank", "Given names: can't be blank",
                       "Surname: can't be blank", 'Terms and conditions must be accepted']

    assert_equal(errors_array.to_set, expected_errors.to_set)
  end

  private

  def assert_appears_before(earlier_element, later_element)
    assert(page.text.index(earlier_element) < page.text.index(later_element))
  end
end
