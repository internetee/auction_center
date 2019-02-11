require 'test_helper'

class OmniauthUserTest < ActiveSupport::TestCase
  def setup
    super

    @omniauth_user = users(:signed_in_with_omniauth)
    @input_hash = {
      'provider' => 'tara',
      'uid' => 'EE51007050604',
      'info' => {
        'first_name' => 'User',
        'last_name' => 'OmniAuth',
        'name' => 'EE51007050604',
      }
    }
  end

  def teardown
    super
  end

  def test_from_omniauth_initializes_user_if_it_does_not_exist
    user = User.from_omniauth(@input_hash)

    assert_equal(user.provider, @input_hash['provider'])
    assert_equal(user.uid, @input_hash['uid'])
    assert_equal(user.given_names, @input_hash.dig('info', 'first_name'))
    assert_equal(user.surname, @input_hash.dig('info', 'last_name'))
    assert_equal(user.identity_code, '51007050604')
    assert_equal(user.country_code, 'EE')

    refute(user.persisted?)
  end

  def test_tampering_protection
    user = User.from_omniauth(@input_hash)
    @input_hash['provider'] = 'not tara'

    assert(user.tampered_with?(@input_hash))
  end

  def test_from_omniauth_does_not_fill_identity_code_if_not_from_tara
    @input_hash['provider'] = 'github'

    user = User.from_omniauth(@input_hash)
    refute_equal(user.identity_code, '51007050604')
    refute_equal(user.country_code, 'EE')
  end

  def test_from_omniauth_finds_user_if_it_exists
    @input_hash['uid'] = 'EE51007050665'
    user = User.from_omniauth(@input_hash)

    assert_equal(@omniauth_user, user)
  end
end
