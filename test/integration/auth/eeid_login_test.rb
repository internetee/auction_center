require 'test_helper'

class EeidLoginTest < ActionDispatch::IntegrationTest
  NEW_USER_UID = 'US123456789'.freeze

  def setup
    super
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/reference_number_generator')
      .to_return(status: 200, body: '{"reference_number":"12332"}', headers: {})
    OmniAuth.config.test_mode = true
    @user = users(:signed_in_with_omniauth)
  end

  def teardown
    OmniAuth.config.mock_auth[:eeid] = nil
    OmniAuth.config.mock_auth[:tara] = nil
    OmniAuth.config.test_mode = false
    super
  end

  def test_eeid_login_returning_to_shared_tara_callback_is_completed_by_eeid
    mock_identity('eeid', @user.uid)

    post '/auth/eeid'
    get '/auth/tara/callback'

    assert_redirected_to root_path
    assert_equal User::EEID_PROVIDER, @user.reload.provider
  end

  def test_tara_login_started_after_abandoned_eeid_login_is_completed_by_tara
    @user.update!(provider: User::EEID_PROVIDER)
    mock_identity('eeid', @user.uid)
    mock_identity('tara', @user.uid)

    post '/auth/eeid'
    post '/auth/tara'
    get '/auth/tara/callback'

    assert_redirected_to root_path
    assert_equal User::TARA_PROVIDER, @user.reload.provider
  end

  def test_new_eeid_user_signs_up_with_identity_from_eeid
    sign_in_with_eeid(NEW_USER_UID)
    assert_response :ok
    assert_includes response.body, eeid_create_path
    assert_difference -> { User.count }, 1 do
      post eeid_create_path, params: { user: sign_up_params }
    end

    user = User.find_by!(identity_code: '123456789', alpha_two_country_code: 'US')
    assert_equal User::EEID_PROVIDER, user.provider
    assert_redirected_to root_path
  end

  def test_sign_up_with_changed_identity_code_is_rejected
    sign_in_with_eeid(NEW_USER_UID)

    assert_no_difference -> { User.count } do
      post eeid_create_path, params: { user: sign_up_params.merge(identity_code: '987654321') }
    end

    assert_redirected_to root_url
    assert_equal I18n.t('auth.eeid.tampering'), flash[:alert]
  end

  def test_sign_up_without_eeid_login_is_rejected
    assert_no_difference -> { User.count } do
      post eeid_create_path, params: { user: sign_up_params }
    end

    assert_redirected_to root_url
  end

  def test_login_without_identity_code_is_rejected
    sign_in_with_eeid('US')

    assert_redirected_to root_path
    assert_equal I18n.t('auth.eeid.identity_code_missing'), flash[:alert]
  end

  def test_sign_in_button_follows_eeid_login_enabled_setting
    get new_user_session_path
    assert_select 'form[action="/auth/tara"]'

    settings(:eeid_login_enabled).update!(value: 'true')
    get new_user_session_path
    assert_select 'form[action="/auth/eeid"]'
  end

  private

  def mock_identity(provider, uid)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new(
      'provider' => provider,
      'uid' => uid,
      'info' => { 'first_name' => 'Jane', 'last_name' => 'Doe' }
    )
  end

  def sign_in_with_eeid(uid)
    mock_identity('eeid', uid)
    post '/auth/eeid'
    get '/auth/tara/callback'
  end

  def sign_up_params
    {
      email: 'jane.doe@auction.test',
      identity_code: '123456789',
      country_code: 'US',
      given_names: 'Jane',
      surname: 'Doe',
      accepts_terms_and_conditions: 'true',
      locale: 'en',
      uid: NEW_USER_UID,
      provider: User::EEID_PROVIDER
    }
  end
end
