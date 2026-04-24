require 'test_helper'

class AdminSettingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = users(:administrator)
    @participant = users(:participant)
    @setting = settings(:application_name)
  end

  def test_index_renders_for_admin
    sign_in @admin

    get admin_settings_path

    assert_response :ok
  end

  def test_show_renders_for_admin
    sign_in @admin

    get admin_setting_path(@setting.id)

    assert_response :ok
    assert_includes response.body, @setting.description
  end

  def test_edit_renders_for_admin
    sign_in @admin

    get edit_admin_setting_path(@setting.id)

    assert_response :ok
  end

  def test_update_redirects_for_admin
    sign_in @admin

    patch admin_setting_path(@setting.id), params: { setting: { value: @setting.value } }

    assert_response :redirect
  end

  def test_index_returns_not_found_for_non_admin
    sign_in @participant

    get admin_settings_path

    assert_response :not_found
  end
end
