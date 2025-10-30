require 'test_helper'

class SafeValueValidatorTest < ActiveSupport::TestCase

  def setup
    @user = User.new
    @user.surname = '"><svg/onload=confirm(1)>'
    @user.given_names = 'Given Names ÖÄÕÜüõöä'
  end

  def test_false_on_invalid_values
    validator = SafeValueValidator.new({attributes: {surname: @user.surname}})
    assert_not(validator.validate_each(@user, :surname, @user.surname))
  end

  def test_true_on_valid_values
    validator = SafeValueValidator.new({attributes: {given_names: @user.given_names}})
    assert(validator.validate_each(@user, :given_names, @user.given_names))
  end

  def test_error_message_includes_invalid_characters
    user = User.new
    user.surname = 'Test,Name&Company'
    validator = SafeValueValidator.new({attributes: {surname: user.surname}})
    validator.validate_each(user, :surname, user.surname)

    error_message = user.errors[:surname].first
    assert_match(/,/, error_message, "Error message should include comma")
    assert_match(/&/, error_message, "Error message should include ampersand")
  end

  def test_error_message_with_single_invalid_character
    user = User.new
    user.surname = 'Test,Name'
    validator = SafeValueValidator.new({attributes: {surname: user.surname}})
    validator.validate_each(user, :surname, user.surname)

    error_message = user.errors[:surname].first
    assert_match(/,/, error_message, "Error message should include comma")
    assert_match(/invalid character/i, error_message, "Error message should mention invalid character")
  end
end
