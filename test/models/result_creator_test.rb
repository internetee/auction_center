require 'test_helper'

class ResultCreatorTest < ActiveSupport::TestCase
  def setup
    super

    @auction_with_result = auctions(:expired)
    @auction_with_offers = auctions(:valid_with_offers)
    @auction_without_offers = auctions(:valid_without_offers)
  end

  def teardown
    super

    clear_email_deliveries
  end

  def test_a_result_is_created_for_auction_with_offers
    Result.destroy_all

    result_creator = ResultCreator.new(@auction_with_offers.id)
    result = result_creator.call

    expected_winning_offer = offers(:high_offer)

    assert(result.is_a?(Result))
    assert_equal(true, result.awaiting_payment?)
    assert_equal(expected_winning_offer, result.offer)
    assert_equal(Date.today + 14, result.registration_due_date)
    assert_equal(@auction_with_offers, result.auction)
  end

  def test_a_result_is_created_for_auction_without_offers
    Result.destroy_all

    result_creator = ResultCreator.new(@auction_without_offers.id)
    result = result_creator.call

    assert(result.is_a?(Result))
    assert_equal(false, result.awaiting_payment?)
    assert_equal(true, result.no_bids?)
    assert_equal(@auction_without_offers, result.auction)
    assert_not(result.user)
    assert_not(result.invoice)
  end

  def test_result_is_created_even_after_a_user_is_deleted
    Result.destroy_all

    participant = users(:participant)
    participant.destroy

    result_creator = ResultCreator.new(@auction_with_offers.id)
    result = result_creator.call

    expected_winning_offer = offers(:minimum_offer)

    assert(result.is_a?(Result))
    assert_equal(true, result.awaiting_payment?)
    assert_equal(expected_winning_offer, result.offer)
    assert_equal(@auction_with_offers, result.auction)
  end

  def test_returns_an_existing_result_if_found
    expected_result = results(:expired_participant)

    result_creator = ResultCreator.new(@auction_with_result.id)
    result = result_creator.call

    assert_equal(expected_result, result)
  end

  def test_return_silently_if_no_auction_was_found
    result_creator = ResultCreator.new(:foo)
    assert_nil(result_creator.call)
  end

  def test_creator_does_not_email_winner_for_auction_without_offers
    result_creator = ResultCreator.new(@auction_without_offers.id)
    result_creator.call

    assert(ActionMailer::Base.deliveries.empty?)
  end

  def test_creator_does_not_email_winner_for_existing_result
    result_creator = ResultCreator.new(@auction_with_result.id)
    result_creator.call

    assert(ActionMailer::Base.deliveries.empty?)
  end

  def test_creator_emails_particiapants_for_auction_with_offers
    result_creator = ResultCreator.new(@auction_with_offers.id)
    result_creator.call

    assert_not(ActionMailer::Base.deliveries.empty?)
    last_email = ActionMailer::Base.deliveries.last

    assert_equal('Bid for the with-offers.test domain was unsuccessful', last_email.subject)
    assert_equal(['second_place@auction.test'], last_email.to)
  end

  def test_creator_emails_winner_for_auction_with_offers
    ActionMailer::Base.deliveries.clear
    result_creator = ResultCreator.new(@auction_with_offers.id)
    result_creator.call

    assert_not(ActionMailer::Base.deliveries.empty?)
    last_email = ActionMailer::Base.deliveries.first

    assert_equal('Bid for the with-offers.test domain was successful', last_email.subject)
    assert_equal(['user@auction.test'], last_email.to)
    linkpay_text = 'You can pay for this invoice using following'
    assert CGI::unescapeHTML(last_email.body.raw_source).include? linkpay_text
  end
end
