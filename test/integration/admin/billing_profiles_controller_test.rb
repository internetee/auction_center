require 'test_helper'

class AdminBillingProfilesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = users(:administrator)
    @participant = users(:participant)
    @billing_profile = billing_profiles(:company)
  end

  def test_index_renders_for_admin
    sign_in_admin

    get admin_billing_profiles_path

    assert_response :ok
    assert_includes response.body, @billing_profile.name
  end

  def test_show_renders_for_admin
    sign_in_admin

    get admin_billing_profile_path(@billing_profile.id)

    assert_response :ok
    assert_includes response.body, @billing_profile.name
  end

  def test_index_returns_not_found_for_non_admin_user
    sign_in_participant

    get admin_billing_profiles_path

    assert_response :not_found
  end

  def test_show_returns_not_found_for_non_admin_user
    sign_in_participant

    get admin_billing_profile_path(@billing_profile.id)

    assert_response :not_found
  end

  private

  def sign_in_admin
    sign_in @admin
  end

  def sign_in_participant
    sign_in @participant
  end
end
