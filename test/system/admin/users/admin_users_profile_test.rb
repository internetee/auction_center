require 'application_system_test_case'

class AdminUsersProfileTest < ApplicationSystemTestCase
  def setup
    super
    @participant = users(:participant)
    @administrator = users(:administrator)

    sign_in(@administrator)
  end

  def test_administrator_can_update_users_role
    visit edit_admin_user_path(@participant)

    check_checkbox('user_roles_administrator')
    uncheck_checkbox('user_roles_participant')
    click_link_or_button('Update')
  end

  def test_administrator_can_update_users_phone_number
    visit edit_admin_user_path(@participant)

    fill_in('user[mobile_phone]', with: '+37255000003')
    click_link_or_button('Update')
    assert_text('+37255000003')

    @participant.reload
    assert_equal("#{@administrator.id} - John Joe Administrator", @participant.updated_by)
  end

  def test_mobile_phone_needs_to_be_valid
    visit edit_admin_user_path(@participant)
    fill_in('user[mobile_phone]', with: '+372 500')
    page.find('body').click # blur
    assert_not(page.has_button?('Update'))

    fill_in('user[mobile_phone]', with: '+37250006000')
    page.find('body').click # blur
    assert(page.has_button?('Update'))
    click_link_or_button('Update')
    assert(page.has_text?('+37250006000'))
  end

  def test_country_can_also_be_changed
    visit edit_admin_user_path(@participant)
    select_from_dropdown('Poland', from: 'user[country_code]')
    click_link_or_button('Update')

    assert(page.has_text?('PL'))
  end

  def test_invalid_phone_number_disables_submit_button
    visit edit_admin_user_path(@participant)

    fill_in('user[mobile_phone]', with: '+372 11111111111111111111111117 1000')
    page.find('body').click # blur

    assert_not(page.has_button?('Submit'))
  end

  def test_administrator_can_delete_user
    visit admin_user_path(@participant)

    accept_confirm do
      click_link_or_button('Delete')
    end

    assert_text('Deleted successfully.')
  end

  def test_administrator_can_see_billing_profiles_attached_to_user
    billing_profile = billing_profiles(:company)
    visit admin_user_path(@participant)

    assert(page.has_link?('ACME Inc.', href: admin_billing_profile_path(billing_profile)))
  end
end
