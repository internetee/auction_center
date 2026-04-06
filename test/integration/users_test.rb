require 'test_helper'

class UsersIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActionMailer::TestHelper

  setup do
    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/reference_number_generator").
      to_return(status: 200, body: "{\"reference_number\":\"12332\"}", headers: {})

    @user = users(:participant)
    sign_in @user
  end

  def test_user_is_notified_about_password_change
    current_password = 'password123'
    new_password = 'new password'

    assert_enqueued_emails 1 do
      patch user_path(@user.uuid), params: { user: { current_password: current_password,
                                                     password: new_password,
                                                     password_confirmation: new_password } }
    end
  end

  def test_edit_authwall_redirects_to_profile
    get user_edit_authwall_path
    assert_redirected_to user_path(@user.uuid)
  end

  def test_toggle_subscription_redirects_and_flips_flag
    before = @user.daily_summary
    get user_toggle_sub_path
    assert_redirected_to root_path
    assert_equal I18n.t('users.toggle_subscription.subscription_status_toggled_flash'), flash[:notice]
    assert_not_equal before, @user.reload.daily_summary
  end

  def test_new_redirects_when_already_signed_in
    get new_user_path
    assert_redirected_to user_path(@user.uuid)
  end

  def test_create_rejects_invalid_user
    sign_out @user

    assert_no_difference('User.count') do
      post users_path, params: {
        user: {
          email: 'invalid-signup@auction.test',
          password: 'password123',
          password_confirmation: 'password123',
          country_code: 'EE',
          given_names: 'X',
          surname: 'Y',
          mobile_phone: '+37250001111',
          accepts_terms_and_conditions: '0',
          identity_code: '51001010065'
        }
      }
    end
    assert_response :unprocessable_entity
  end

  def test_show_profile
    get user_path(@user.uuid)
    assert_response :success
  end

  def test_edit_renders_form_for_turbo_frame
    get edit_user_path(@user.uuid), headers: { 'Turbo-Frame' => 'user-edit' }
    assert_response :success
  end

  def test_update_with_incorrect_password_sets_flash_via_turbo_stream
    patch user_path(@user.uuid),
          params: { user: { current_password: 'wrong', given_names: @user.given_names } },
          as: :turbo_stream
    assert_response :success
    assert_match 'turbo-stream', response.body
  end

  def test_update_with_invalid_mobile_sets_validation_flash
    patch user_path(@user.uuid),
          params: { user: { current_password: 'password123', mobile_phone: 'not-valid' } },
          as: :turbo_stream
    assert_response :success
    assert_match 'turbo-stream', response.body
  end

  def test_update_success_redirects_and_persists_changes
    patch user_path(@user.uuid),
          params: { user: { current_password: 'password123', given_names: 'NewName' } }

    assert_redirected_to user_path(@user.uuid)
    assert_equal 'NewName', @user.reload.given_names
  end

  def test_destroy_when_not_deletable_redirects_with_notice
    assert @user.invoices.issued.exists?

    assert_no_difference('User.count') do
      delete user_path(@user.uuid)
    end
    assert_redirected_to user_path(@user.uuid)
    assert_equal I18n.t('users.destroy.cannot_delete'), flash[:notice]
  end

  def test_destroy_when_deletable_redirects_to_root
    deletable = users(:second_place_participant)
    deletable.webpush_subscription.destroy!
    deletable.reload
    sign_in deletable
    assert deletable.invoices.issued.blank?

    assert_difference('User.count', -1) do
      delete user_path(deletable.uuid)
    end
    assert_redirected_to root_path
    assert_equal I18n.t('users.destroy.deleted'), flash[:notice]
  end

  def test_guest_can_open_sign_up_form
    sign_out @user

    get new_user_path
    assert_response :success
  end
end
