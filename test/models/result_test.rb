require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  def setup
    super

    clear_email_deliveries
    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
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

    assert_not(result.valid?)

    assert_equal(['must exist'], result.errors[:auction], result.errors.full_messages)
  end

  def test_status_predicates
    result = Result.new

    assert_equal(false, result.no_bids?)
    assert_equal(false, result.payment_received?)
    assert_equal(false, result.payment_not_received?)
    assert_equal(false, result.domain_registered?)
    assert_equal(false, result.domain_not_registered?)
  end

  def test_create_result_from_an_auction_only_works_if_the_auction_has_finished
    assert_raises(Errors::AuctionNotFinished) do
      Result.create_from_auction(@valid_auction.id)
    end

    assert_raises(Errors::AuctionNotFound) do
      Result.create_from_auction('foo')
    end
  end

  def test_winning_offer_is_an_alias_on_offer
    assert_equal(@invoiceable_result.offer, @invoiceable_result.winning_offer)
  end

  def test_send_email_to_winner_does_nothing_if_there_is_no_winner
    result = Result.new(status: :no_bids)

    result.send_email_to_winner
    assert(ActionMailer::Base.deliveries.empty?)
  end

  def test_send_email_to_winner_sends_an_email_if_winner_exists
    Invoice.create_from_result(@invoiceable_result.id)
    @invoiceable_result.send_email_to_winner

    assert_not(ActionMailer::Base.deliveries.empty?)
    email = ActionMailer::Base.deliveries.last

    assert_equal(['user@auction.test'], email.to)
    assert_equal('Bid for the expired.test domain was successful', email.subject)
  end

  def test_marking_as_payment_received_updates_registration_due_date
    @invoiceable_result.mark_as_payment_received(Time.parse('2010-07-06 10:30 +0000').in_time_zone)

    assert_equal(Date.parse('2010-07-20'), @invoiceable_result.registration_due_date)
    assert_equal(Result.statuses[:payment_received], @invoiceable_result.status)
  end

  def test_pending_invoice_scope_does_not_return_results_that_had_no_bids
    assert_equal([@invoiceable_result].to_set, Result.pending_invoice.to_set)
    assert_equal([@invoiceable_result, @noninvoiceable_result,
                  @orphaned_result, @with_invoice_result].to_set,
                 Result.all.to_set)
  end

  def test_pending_status_report_does_not_return_results_that_reported_their_latest_status
    assert_equal([@noninvoiceable_result].to_set, Result.pending_status_report.to_set)
  end

  def test_pending_registration_returns_results_with_payment_received_status
    @noninvoiceable_result.update!(status: :payment_received)
    assert_equal([@noninvoiceable_result].to_set, Result.pending_registration.to_set)
  end

  def test_registration_code_returns_the_stored_value
    assert_equal('332c70cdd0791d185778e0cc2a4eddea', @invoiceable_result.registration_code)
    assert_nil(@noninvoiceable_result.registration_code)
  end
end
