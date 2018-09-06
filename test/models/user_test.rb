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
    assert_equal(["can't be blank"], user.errors[:identity_code])

    user.email = 'email@example.com'
    user.password = 'email@example.com'
    user.password_confirmation = 'email@example.com'
    user.mobile_phone = '+372500100300'
    user.identity_code = '51007050687'

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
end
