require 'test_helper'

module Auth
  class TaraControllerTest < ActionController::TestCase
    OMNIAUTH_AUTH_KEY = 'omniauth.auth'

    tests Auth::TaraController
    include Devise::Test::ControllerHelpers

    def setup
      @user = users(:participant)
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end

    def with_omniauth_hash(hash)
      previous = @request.env[OMNIAUTH_AUTH_KEY]
      @request.env[OMNIAUTH_AUTH_KEY] = hash
      yield
    ensure
      @request.env[OMNIAUTH_AUTH_KEY] = previous
    end

    def test_callback_redirects_and_signs_in_when_user_is_persisted
      omniauth_hash = {
        'uid' => 'EE51007050120',
        'info' => { 'email' => @user.email },
        'credentials' => { 'token' => 'secret-token' }
      }

      with_omniauth_hash(omniauth_hash) do
        User.stub(:from_omniauth, @user) do
          get :callback
        end
      end

      assert_redirected_to root_path
      assert_not_nil session['warden.user.user.key']
      assert_not session[:omniauth_hash].key?('credentials')
    end

    def test_callback_renders_callback_when_user_is_not_persisted
      new_user = User.new
      omniauth_hash = {
        'uid' => 'EE51007050120',
        'info' => { 'email' => 'new@example.test' },
        'credentials' => { 'token' => 'secret-token' }
      }

      with_omniauth_hash(omniauth_hash) do
        User.stub(:from_omniauth, new_user) do
          get :callback
        end
      end

      assert_response :ok
      assert_includes response.body, tara_create_path
      assert_not session[:omniauth_hash].key?('credentials')
    end

    def test_callback_sets_invalid_user_data_flag_in_session
      omniauth_hash = {
        'uid' => 'EE51007050120',
        'info' => { 'email' => @user.email },
        'credentials' => { 'token' => 'secret-token' }
      }

      with_omniauth_hash(omniauth_hash) do
        User.stub(:from_omniauth, @user) do
          get :callback
        end
      end

      assert session.key?('user.invalid_user_data'),
             'TARA callback must set the invalid_user_data flag, otherwise the ' \
             'static notice will silently skip rendering for eID-authenticated ' \
             'users (parity with Auth::SessionsController#create).'
      assert_equal false, session['user.invalid_user_data']
    end

    def test_callback_flags_invalid_user_data_when_user_has_unsafe_characters
      bad_user = @user
      bad_user.given_names = 'Ёшкин Кот'

      omniauth_hash = {
        'uid' => 'EE51007050120',
        'info' => { 'email' => bad_user.email },
        'credentials' => { 'token' => 'secret-token' }
      }

      with_omniauth_hash(omniauth_hash) do
        User.stub(:from_omniauth, bad_user) do
          get :callback
        end
      end

      assert_equal true, session['user.invalid_user_data']
    end
  end
end
