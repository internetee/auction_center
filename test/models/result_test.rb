require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000')
    @expired_auction = auctions(:expired)
  end

  def teardown
    super

    travel_back
  end

  def test_required_fields
    result = Result.new

    refute(result.valid?)

    assert_equal(["must exist"], result.errors[:auction])
    assert_equal(["can't be blank"], result.errors[:sold])
  end
end
