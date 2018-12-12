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
    assert_equal(true, result.sold?)
    assert_equal(expected_winning_offer, result.offer)
    assert_equal(@auction_with_offers, result.auction)
  end

  def test_a_result_is_created_for_auction_without_offers
    Result.destroy_all

    result_creator = ResultCreator.new(@auction_without_offers.id)
    result = result_creator.call

    assert(result.is_a?(Result))
    assert_equal(false, result.sold?)
    assert_equal(@auction_without_offers, result.auction)
    refute(result.user)
    refute(result.invoice)
  end

  def test_result_is_created_even_after_a_user_is_deleted
    Result.destroy_all

    participant = users(:participant)
    participant.destroy

    result_creator = ResultCreator.new(@auction_with_offers.id)
    result = result_creator.call

    expected_winning_offer = offers(:minimum_offer)

    assert(result.is_a?(Result))
    assert_equal(true, result.sold?)
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

  def test_creator_emails_winner_for_auction_with_offers
    result_creator = ResultCreator.new(@auction_with_offers.id)
    result_creator.call

    refute(ActionMailer::Base.deliveries.empty?)
    last_email = ActionMailer::Base.deliveries.last

    assert_equal('You won an auction!', last_email.subject)
    assert_equal(['user@auction.test'], last_email.to)
  end
end
