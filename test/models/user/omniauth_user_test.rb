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
      },
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

    assert_not(user.persisted?)
  end

  def test_tampering_protection
    user = User.from_omniauth(@input_hash)
    @input_hash['provider'] = 'not tara'

    assert(user.tampered_with?(@input_hash))
  end

  def test_from_omniauth_finds_user_if_it_exists
    @input_hash['uid'] = 'EE51007050665'
    user = User.from_omniauth(@input_hash)

    assert_equal(@omniauth_user, user)
  end

  def test_eeid_login_takes_over_existing_tara_user
    @input_hash['provider'] = User::EEID_PROVIDER
    @input_hash['uid'] = 'EE51007050665'
    user = User.from_omniauth(@input_hash)

    assert_equal(@omniauth_user, user)
    assert_equal(User::EEID_PROVIDER, user.reload.provider)
    assert(user.signed_in_with_identity_document?)
  end

  def test_eeid_eidas_subject_is_split_into_country_and_code
    @input_hash['provider'] = User::EEID_PROVIDER
    @input_hash['uid'] = 'PNOLV-123456-12345'
    user = User.from_omniauth(@input_hash)

    assert_equal('LV', user.country_code)
    assert_equal('123456-12345', user.identity_code)
    assert_not(user.tampered_with?(@input_hash))
  end

  def test_foreign_identity_code_does_not_match_user_from_another_country
    @omniauth_user.update_columns(alpha_two_country_code: 'LV', identity_code: 'A1234567',
                                  uid: 'LVA1234567')
    @input_hash['provider'] = User::EEID_PROVIDER
    @input_hash['uid'] = 'USA1234567'
    user = User.from_omniauth(@input_hash)

    assert_not(user.persisted?)
    assert_equal('US', user.country_code)
    assert_equal('A1234567', user.identity_code)
  end

  def test_tampering_detected_when_identity_code_changed_for_eeid_subject
    @input_hash['provider'] = User::EEID_PROVIDER
    @input_hash['uid'] = 'PNOLV-123456-12345'
    user = User.from_omniauth(@input_hash)
    user.identity_code = '123456-99999'

    assert(user.tampered_with?(@input_hash))
  end
end
