require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000')
    @valid_auction = auctions(:valid_with_offers)
    @expired_auction = auctions(:expired)
  end

  def teardown
    super

    clear_email_deliveries
    travel_back
  end

  def test_required_fields
    result = Result.new

    refute(result.valid?)

    assert_equal(["must exist"], result.errors[:auction])
    assert_equal(["is not included in the list"], result.errors[:sold])
  end

  def test_sold_returns_boolean
    result = Result.new

    assert_equal(false, result.sold?)
  end

  def test_create_result_from_an_auction_only_works_if_the_auction_has_finished
    assert_raises(Errors::AuctionNotFinished) do
      Result.create_from_auction(@valid_auction.id)
    end

    assert_raises(Errors::AuctionNotFound) do
      Result.create_from_auction("foo")
    end
  end

  def test_price_is_a_money_object
    result = Result.new(cents: 1000)

    assert_equal(Money.new(1000, Setting.auction_currency), result.price)

    result.cents = nil
    assert_equal(Money.new(0, Setting.auction_currency), result.price)
  end

  def test_send_email_to_winner_does_nothing_if_there_is_no_winner
    result = Result.new(sold: false)

    result.send_email_to_winner
    assert(ActionMailer::Base.deliveries.empty?)
  end

  def test_send_email_to_winner_sends_an_email_if_winner_exists
    result = results(:expired_participant)
    result.send_email_to_winner

    refute(ActionMailer::Base.deliveries.empty?)
    email = ActionMailer::Base.deliveries.last

    assert_equal(['user@auction.test'], email.to)
    assert_equal('You won an auction!', email.subject)
  end
end
