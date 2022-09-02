require 'application_system_test_case'

class AdminSettingsTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:administrator)
    sign_in(@user)
  end

  # def test_administrator_can_update_settings_value
  #   visit admin_settings_path
  #   click_link_or_button('application_name')
  #   click_link_or_button('Edit')

  #   fill_in('setting[value]', with: 'New Application Name')
  #   click_link_or_button('Submit')
  #   assert(page.has_text?('Updated successfully'))
  #   assert(page.has_text?('New Application Name'))

  #   setting = Setting.find_by(code: 'application_name')
  #   assert_equal('New Application Name', setting.value)
  # end

  # def test_administrator_can_update_settings_description
  #   visit admin_settings_path
  #   click_link_or_button('application_name')
  #   click_link_or_button('Edit')
  #   fill_in('setting[description]', with: 'This setting is unused')

  #   click_link_or_button('Submit')
  #   assert(page.has_text?('Updated successfully'))
  #   assert(page.has_text?('This setting is unused'))

  #   setting = Setting.find_by(code: 'application_name')
  #   assert_equal('This setting is unused', setting.description)

  #   assert_equal("#{@user.id} - John Joe Administrator", setting.updated_by)
  # end
end
