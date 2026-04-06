require 'test_helper'

module Auth
  class TaraControllerTest < ActionController::TestCase
    tests Auth::TaraController
    include Devise::Test::ControllerHelpers

    def setup
      @user = users(:participant)
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end

    def with_omniauth_hash(hash)
      previous = @request.env['omniauth.auth']
      @request.env['omniauth.auth'] = hash
      yield
    ensure
      @request.env['omniauth.auth'] = previous
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
  end
end
