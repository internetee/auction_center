require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    super

    @administrator = users(:administrator)
  end

  def test_required_fields
    user = User.new

    refute(user.valid?)
    assert_equal(["can't be blank"], user.errors[:password])
    assert_equal(["can't be blank"], user.errors[:email])
    assert_equal(["can't be blank"], user.errors[:mobile_phone])
    assert_equal(["must be accepted"], user.errors[:terms_and_conditions])
    assert_equal(["can't be blank"], user.errors[:given_names])
    assert_equal(["can't be blank"], user.errors[:surname])

    user.email = 'email@example.com'
    user.password = 'email@example.com'
    user.password_confirmation = 'email@example.com'
    user.surname = 'Surname'
    user.given_names = 'Given Names'
    user.mobile_phone = '+372500100300'
    user.identity_code = '51007050687'
    user.country_code = 'EE'
    user.accepts_terms_and_conditions = true

    assert(user.valid?)
  end

  def test_identity_code_can_be_empty_if_not_estonian
    user = User.new

    user.surname = 'Surname'
    user.given_names = 'Given Names'
    user.email = 'email@example.com'
    user.password = 'email@example.com'
    user.password_confirmation = 'email@example.com'
    user.mobile_phone = '+372500100300'
    user.country_code = 'PL'
    user.accepts_terms_and_conditions = "true"

    assert(user.valid?)
  end

  def test_password_needs_a_confirmation
    @administrator.password = 'password'
    @administrator.password_confirmation = 'not matching'

    refute(@administrator.valid?)
    assert_equal(["doesn't match Password"], @administrator.errors[:password_confirmation])

    @administrator.password_confirmation = 'password'
    assert(@administrator.valid?)
  end

  def test_email_must_be_unique
    new_user = User.new(email: @administrator.email, password: 'password',
                        password_confirmation: 'password')

    refute(new_user.valid?)
    assert_equal(['has already been taken'], new_user.errors[:email])
  end

  def test_identity_code_must_be_unique_for_a_country
    new_user = User.new(identity_code: @administrator.identity_code,
                        country_code: @administrator.country_code)

    refute(new_user.valid?)
    assert_equal(['has already been taken'], new_user.errors[:identity_code])
  end

  def test_country_code_is_an_alias
    user = User.new
    user.alpha_two_country_code = 'EE'
    assert_equal('EE', user.country_code)
  end

  def test_country_code_must_be_two_letters_long
    @administrator.country_code = 'EST'
    assert_raise ActiveRecord::ValueTooLong do
      @administrator.save
    end
  end

  def test_display_name
    @administrator.given_names = 'New Given Name'
    @administrator.save

    assert_equal('New Given Name Administrator', @administrator.display_name)
  end

  def test_accepts_terms_and_conditions_are_only_updated_when_needed
    original_terms_and_conditions_accepted_at = @administrator.terms_and_conditions_accepted_at
    @administrator.update(accepts_terms_and_conditions: true)

    assert_equal(original_terms_and_conditions_accepted_at,
                 @administrator.terms_and_conditions_accepted_at)

    @administrator.update(accepts_terms_and_conditions: false)
    @administrator.update(accepts_terms_and_conditions: true)

    refute_equal(original_terms_and_conditions_accepted_at,
                 @administrator.terms_and_conditions_accepted_at)
  end

  def test_has_default_role
    user = User.new

    assert_equal([User::PARTICIPANT_ROLE], user.roles)
    assert(user.role?(User::PARTICIPANT_ROLE))
    refute(user.role?(User::ADMINISTATOR_ROLE))
  end

  def test_identity_code_validation_in_estonia
    user = boilerplate_user
    user.mobile_phone = '+372500100300'
    user.identity_code = '05071020395'
    user.country_code = 'EE'
    refute(user.valid?)

    user.identity_code = '51007050360'
    assert(user.valid?)
  end

  def test_localized_validations_are_ignored_for_different_countries
    user = boilerplate_user

    user.mobile_phone = '+3727271000'
    user.identity_code = '05071020395'
    user.country_code = 'LV'

    assert(user.valid?)
  end

  def boilerplate_user
    user = User.new
    user.email = 'email@example.com'
    user.password = 'email@example.com'
    user.password_confirmation = 'email@example.com'
    user.accepts_terms_and_conditions = true
    user.surname = 'Surname'
    user.given_names = 'Given Names'
    user
  end
end
