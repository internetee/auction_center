require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000')
    @valid_auction = auctions(:valid_with_offers)
    @expired_auction = auctions(:expired)

    @invoiceable_result = results(:expired_participant)
    @noninvoiceable_result = results(:without_offers_nobody)
    @orphaned_result = results(:orphaned)
    @with_invoice_result = results(:with_invoice)
  end

  def teardown
    super

    clear_email_deliveries
    travel_back
  end

  def test_required_fields
    result = Result.new

    refute(result.valid?)

    assert_equal(["must exist"], result.errors[:auction], result.errors.full_messages)
  end

  def test_status_predicates
    result = Result.new

    assert_equal(false, result.sold?)
    assert_equal(false, result.expired?)
    assert_equal(false, result.paid?)
  end

  def test_create_result_from_an_auction_only_works_if_the_auction_has_finished
    assert_raises(Errors::AuctionNotFinished) do
      Result.create_from_auction(@valid_auction.id)
    end

    assert_raises(Errors::AuctionNotFound) do
      Result.create_from_auction("foo")
    end
  end

  def test_winning_offer_is_an_alias_on_offer
    result = results(:expired_participant)

    assert_equal(result.offer, result.winning_offer)
  end

  def test_send_email_to_winner_does_nothing_if_there_is_no_winner
    result = Result.new(status: :expired)

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

  def test_pending_invoice_scope_does_not_return_results_that_are_not_sold
    assert_equal([@invoiceable_result].to_set, Result.pending_invoice.to_set)
    assert_equal([@invoiceable_result, @noninvoiceable_result,
                  @orphaned_result, @with_invoice_result].to_set,
                 Result.all.to_set)
  end
end
