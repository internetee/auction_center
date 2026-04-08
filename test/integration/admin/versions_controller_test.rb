require 'test_helper'

class AdminVersionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = users(:administrator)
    @participant = users(:participant)
  end

  def test_index_renders_for_admin_on_user_versions_path
    sign_in @admin

    get admin_user_versions_path(@admin)

    assert_response :ok
  end

  def test_index_returns_not_found_for_non_admin_user
    sign_in @participant

    get admin_user_versions_path(@admin)

    assert_response :not_found
  end
end
