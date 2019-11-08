require 'test_helper'
require 'identity_code'

class IdentityCodeTest < ActiveSupport::TestCase
  def test_is_always_valid_for_other_countries
    identity_code = IdentityCode.new('FI', 'Foobar')
    assert(identity_code.valid?)
  end

  def test_runs_validations_for_estonia
    identity_code = IdentityCode.new('EE', 'Foobar')
    assert_not(identity_code.valid?)
  end

  def test_is_valid_randomly_for_estonian_id_codes
    array_of_codes = %w[51007050316 51007050327 51007050338
                        51007050349 51007050352 51007050360
                        51007050371 51007050382 51007050393
                        51007050403 51007050414 51007050425
                        51007050436 51007050447 51007050458
                        51007050469 51007050470 51007050480
                        51007050491 51007050501 51007050512
                        51007050523 51007050534 51007050545
                        51007050556 51007050567 51007050578
                        51007050589 51007050597 51007050604
                        51007050610 51007050621 51007050632
                        51007050643 51007050654 51007050665
                        51007050676 51007050687]

    identity_code = IdentityCode.new('EE', array_of_codes.sample)
    assert(identity_code.valid?)
  end

  def test_validates_estonian_id_codes_correctly

    # Valid estonian ID code for person born in 19th century
    identity_code = IdentityCode.new('EE', "14501234213")
    assert(identity_code.valid?)

    # Valid estonian ID code for person born in 20th century
    identity_code = IdentityCode.new('EE', "38701234218")
    assert(identity_code.valid?)

    # Valid estonian ID code for person born in 21th century
    identity_code = IdentityCode.new('EE', "60901234211")
    assert(identity_code.valid?)

    # Incorrect estonian ID codes
    identity_code = IdentityCode.new('EE', "29511234213")
    assert(identity_code.invalid?)

    identity_code = IdentityCode.new('EE', "52501233210")
    assert(identity_code.invalid?)

    identity_code = IdentityCode.new('EE', "44501234213")
    assert(identity_code.invalid?)

  end
end
