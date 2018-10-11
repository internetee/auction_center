require 'test_helper'

class AuctionTest < ActiveSupport::TestCase
  def test_required_fields
    auction = Auction.new

    refute(auction.valid?)
    assert_equal(["can't be blank"], auction.errors[:domain_name])
    assert_equal(["can't be blank"], auction.errors[:ends_at])

    auction.domain_name = 'domain-to-auction.test'
    auction.ends_at = Time.now + 2.days
    assert(auction.valid?)
  end
end
