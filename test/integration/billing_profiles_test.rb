require 'test_helper'

class BillingProfilesTest < ActionDispatch::IntegrationTest
  TURBO_STREAM_MIME = 'text/vnd.turbo-stream.html'

  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:participant)
    @billing_profile = billing_profiles(:company)
    @billing_profile_for_destroy_success = billing_profiles(:unused)
    @billing_profile_for_destroy_failure = billing_profiles(:company)
    sign_in @user
  end

  def test_index_renders_user_billing_profiles
    get billing_profiles_path

    assert_response :ok
    assert_includes response.body, @billing_profile.name
  end

  def test_new_renders_turbo_frame_form
    get new_billing_profile_path,
        headers: { 'Turbo-Frame' => 'new_billing_profile' }

    assert_response :ok
    assert_includes response.body, 'new_form'
  end

  def test_create_success_renders_turbo_stream
    assert_difference -> { BillingProfile.count }, 1 do
      post billing_profiles_path,
           params: {
             billing_profile: {
               user_id: @user.id,
               name: 'ACME2 Inc.',
               vat_code: '',
               street: 'Baker Street 221B',
               city: 'London',
               postal_code: 'NW1 6XE',
               country_code: 'GB'
             }
           },
           headers: { 'Accept' => TURBO_STREAM_MIME }
    end

    assert_response :success
    assert_includes response.media_type, 'turbo-stream'
  end

  def test_create_failure_renders_turbo_stream_flash_alert
    assert_no_difference -> { BillingProfile.count } do
      post billing_profiles_path,
           params: {
             billing_profile: {
               user_id: @user.id,
               name: ''
             }
           },
           headers: { 'Accept' => TURBO_STREAM_MIME }
    end

    assert_response :success
    assert_includes response.media_type, 'turbo-stream'
    assert_includes response.body, "can&#39;t be blank"
  end

  def test_edit_renders_form_partial
    get edit_billing_profile_path(@billing_profile.uuid)

    assert_response :ok
    assert_includes response.body, 'c-account__form'
  end

  def test_update_success_redirects_to_index
    EisBilling::UpdateInvoiceDataService.stub(:call, OpenStruct.new(result?: true)) do
      patch billing_profile_path(@billing_profile.uuid),
            params: {
              billing_profile: {
                name: 'ACME Updated Inc.',
                vat_code: '',
                street: 'Baker Street 221B',
                city: 'London',
                postal_code: 'NW1 6XE',
                country_code: 'GB'
              }
            }
    end

    assert_response :redirect
    assert_redirected_to billing_profiles_path
  end

  def test_update_failure_rerenders_edit_with_unprocessable_entity
    EisBilling::UpdateInvoiceDataService.stub(:call, OpenStruct.new(result?: true)) do
      patch billing_profile_path(@billing_profile.uuid),
            params: {
              billing_profile: {
                name: ''
              }
            },
            headers: { 'Accept' => TURBO_STREAM_MIME }
    end

    assert_response :success
    assert_includes response.body, "can&#39;t be blank"
  end

  def test_destroy_success_deletes_record
    assert_difference -> { BillingProfile.count }, -1 do
      delete billing_profile_path(@billing_profile_for_destroy_success.uuid),
             headers: { 'Accept' => TURBO_STREAM_MIME }
    end

    assert_response :success
    assert_includes response.body, 'flash'
  end

  def test_destroy_failure_renders_turbo_stream
    assert_no_difference -> { BillingProfile.count } do
      delete billing_profile_path(@billing_profile_for_destroy_failure.uuid),
             headers: { 'Accept' => TURBO_STREAM_MIME }
    end

    assert_response :success
    assert_includes response.body, 'flash'
  end
end
