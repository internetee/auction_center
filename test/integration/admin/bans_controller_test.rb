require 'test_helper'

class AdminBansControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = users(:administrator)
    @participant = users(:participant)
    @ban = Ban.create!(user: @participant, valid_until: 1.day.from_now)
  end

  def test_index_renders_for_admin
    sign_in @admin

    get admin_bans_path

    assert_response :ok
    assert_includes response.body, @participant.surname
  end

  def test_create_creates_ban_for_admin
    sign_in @admin

    assert_difference('Ban.count', 1) do
      post admin_bans_path, params: { ban: { user_id: @participant.id, valid_until: 2.days.from_now.to_date } }
    end

    assert_redirected_to admin_bans_path
  end

  def test_create_redirects_to_user_when_validation_fails
    sign_in @admin

    assert_no_difference('Ban.count') do
      post admin_bans_path, params: { ban: { user_id: @participant.id, valid_until: nil } }
    end

    assert_redirected_to admin_user_path(@participant)
  end

  def test_create_returns_internal_server_error_for_valid_json_request
    sign_in @admin

    assert_difference('Ban.count', 1) do
      post admin_bans_path,
           params: { ban: { user_id: @participant.id, valid_until: 2.days.from_now.to_date } },
           as: :json
    end

    assert_response :internal_server_error
  end

  def test_destroy_deletes_ban_for_admin
    sign_in @admin

    assert_difference('Ban.count', -1) do
      delete admin_ban_path(@ban.id)
    end

    assert_redirected_to admin_bans_path
  end

  def test_destroy_returns_no_content_for_json
    sign_in @admin

    assert_difference('Ban.count', -1) do
      delete admin_ban_path(@ban.id), as: :json
    end

    assert_response :no_content
  end

  def test_index_returns_not_found_for_non_admin
    sign_in @participant

    get admin_bans_path

    assert_response :not_found
  end
end
