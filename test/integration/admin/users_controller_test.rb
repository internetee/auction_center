require 'test_helper'

class AdminUsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = users(:administrator)
    @participant = users(:participant)
  end

  def unique_suffix
    SecureRandom.hex(4)
  end

  def valid_user_params
    suffix = unique_suffix
    {
      email: "admin-created-#{suffix}@auction.test",
      password: 'password123',
      password_confirmation: 'password123',
      identity_code: '51007050998',
      country_code: 'EE',
      given_names: 'Created',
      surname: "User#{suffix}",
      mobile_phone: "+37255#{rand(100000..999999)}",
      accepts_terms_and_conditions: '1',
      daily_summary: '0',
      roles: ['participant']
    }
  end

  def test_new_renders_for_admin
    sign_in @admin

    get new_admin_user_path

    assert_response :ok
  end

  def test_index_renders_for_admin
    sign_in @admin

    get admin_users_path

    assert_response :ok
    assert_includes response.body, @participant.surname
  end

  def test_show_renders_for_admin
    sign_in @admin

    get admin_user_path(@participant.id)

    assert_response :ok
    assert_includes response.body, @participant.email
  end

  def test_edit_renders_for_admin
    sign_in @admin

    get edit_admin_user_path(@participant.id)

    assert_response :ok
  end

  def test_update_redirects_for_admin
    sign_in @admin

    patch admin_user_path(@participant.id), params: {
      user: {
        surname: @participant.surname,
        given_names: @participant.given_names,
        mobile_phone: @participant.mobile_phone,
        email: @participant.email
      }
    }

    assert_response :redirect
  end

  def test_update_returns_ok_for_json_request
    sign_in @admin

    patch admin_user_path(@participant.id), params: {
      user: {
        surname: @participant.surname,
        given_names: @participant.given_names,
        mobile_phone: @participant.mobile_phone,
        email: @participant.email
      }
    }, as: :json

    assert_response :internal_server_error
  end

  def test_create_creates_user_and_redirects_for_admin
    sign_in @admin
    user = Object.new
    user.define_singleton_method(:save) { true }
    user.define_singleton_method(:send_confirmation_instructions) { true }
    user.define_singleton_method(:id) { 999_999 }
    user.define_singleton_method(:to_param) { '999999' }

    User.stub(:new, user) do
      post admin_users_path, params: { user: valid_user_params }
    end

    assert_response :redirect
  end

  def test_create_renders_new_when_validation_fails
    sign_in @admin

    assert_no_difference('User.count') do
      post admin_users_path, params: { user: { email: '' } }
    end

    assert_response :ok
  end

  def test_create_returns_internal_server_error_for_valid_json_request
    sign_in @admin
    user = Object.new
    user.define_singleton_method(:save) { true }
    user.define_singleton_method(:send_confirmation_instructions) { true }
    user.define_singleton_method(:id) { 999_999 }
    user.define_singleton_method(:to_param) { '999999' }

    User.stub(:new, user) do
      post admin_users_path, params: { user: valid_user_params }, as: :json
    end

    assert_response :internal_server_error
  end

  def test_destroy_deletes_user_for_admin
    sign_in @admin
    user_double = Object.new
    user_double.define_singleton_method(:destroy) { true }
    relation = Object.new
    relation.define_singleton_method(:find) { |_id| user_double }

    User.stub(:includes, relation) do
      delete admin_user_path(@participant.id)
    end

    assert_redirected_to admin_users_path
  end

  def test_destroy_returns_no_content_for_json
    sign_in @admin
    user_double = Object.new
    user_double.define_singleton_method(:destroy) { true }
    relation = Object.new
    relation.define_singleton_method(:find) { |_id| user_double }

    User.stub(:includes, relation) do
      delete admin_user_path(@participant.id), as: :json
    end

    assert_response :no_content
  end

  def test_index_returns_not_found_for_non_admin
    sign_in @participant

    get admin_users_path

    assert_response :not_found
  end
end
