require 'test_helper'

class AuthTaraControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:participant)
  end

  def with_omniauth_hash(hash)
    previous = Rails.application.env_config['omniauth.auth']
    Rails.application.env_config['omniauth.auth'] = hash
    yield
  ensure
    Rails.application.env_config['omniauth.auth'] = previous
  end

  def test_cancel_redirects_to_root
    get tara_cancel_path

    assert_redirected_to root_path
  end

  def test_create_redirects_when_user_saves
    params = {
      user: {
        email: @user.email,
        identity_code: @user.identity_code,
        country_code: @user.country_code,
        given_names: @user.given_names,
        surname: @user.surname,
        accepts_terms_and_conditions: '1',
        locale: @user.locale,
        uid: @user.uid || 'EE51007050120',
        provider: @user.provider || 'tara'
      }
    }

    @user.stub(:save, true) do
      User.stub(:new, @user) do
        post tara_create_path, params: params
      end
    end

    assert_response :redirect
  end

  def test_create_renders_callback_when_user_save_fails
    params = {
      user: {
        email: @user.email,
        identity_code: @user.identity_code,
        country_code: @user.country_code,
        given_names: @user.given_names,
        surname: @user.surname,
        accepts_terms_and_conditions: '1',
        locale: @user.locale,
        uid: @user.uid || 'EE51007050120',
        provider: @user.provider || 'tara'
      }
    }

    @user.stub(:save, false) do
      User.stub(:new, @user) do
        post tara_create_path, params: params
      end
    end

    assert_response :ok
    assert_includes response.body, tara_create_path
  end

  def test_create_returns_bad_request_without_user_params
    post tara_create_path, params: {}
    assert_response :bad_request
  end

  def test_create_redirects_to_root_when_tampering_detected
    params = {
      user: {
        email: @user.email,
        identity_code: @user.identity_code,
        country_code: @user.country_code,
        given_names: @user.given_names,
        surname: @user.surname,
        accepts_terms_and_conditions: '1',
        locale: @user.locale,
        uid: @user.uid || 'EE51007050120',
        provider: @user.provider || 'tara'
      }
    }

    tampering_proc = ->(_args = nil) { raise Errors::TamperingDetected }
    User.stub(:new, tampering_proc) do
      post tara_create_path, params: params
    end

    assert_redirected_to root_url
  end
end
