require 'test_helper'

class ResultCreatorTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  include ActionMailer::TestHelper

  def setup
    super

    @auction_with_result = auctions(:expired)
    @auction_with_offers = auctions(:valid_with_offers)
    @auction_without_offers = auctions(:valid_without_offers)

    invoice_n = Invoice.order(number: :desc).last.number
    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_number_generator")
      .to_return(status: 200, body: "{\"invoice_number\":\"#{invoice_n + 3}\"}", headers: {})

    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_generator")
      .to_return(status: 200, body: "{\"everypay_link\":\"http://link.test\"}", headers: {})

    stub_request(:put, "http://registry:3000/eis_billing/e_invoice_response").
      to_return(status: 200, body: "{\"invoice_number\":\"#{invoice_n + 3}\"}, {\"date\":\"#{Time.zone.now-10.minutes}\"}", headers: {})

    stub_request(:post, "http://eis_billing_system:3000/api/v1/e_invoice/e_invoice").
      to_return(status: 200, body: "", headers: {})
  end

  def teardown
    super

    clear_email_deliveries
  end

  def test_a_result_is_created_for_auction_with_offers
    Result.destroy_all

    mock = Minitest::Mock.new
    def mock.authorized; true; end

    clazz = EisBilling::BaseController.new

    clazz.stub :authorized, mock do
      result_creator = ResultCreator.new(@auction_with_offers.id)
      result = result_creator.call

      expected_winning_offer = offers(:high_offer)

      assert(result.is_a?(Result))
      assert_equal(true, result.awaiting_payment?)
      assert_equal(expected_winning_offer, result.offer)
      assert_equal(Date.today + 14, result.registration_due_date)
      assert_equal(@auction_with_offers, result.auction)
    end
  end

  def test_a_result_is_created_for_auction_without_offers
    Result.destroy_all

    mock = Minitest::Mock.new
    def mock.authorized; true; end

    clazz = EisBilling::BaseController.new

    clazz.stub :authorized, mock do
      result_creator = ResultCreator.new(@auction_without_offers.id)
      result = result_creator.call

      assert(result.is_a?(Result))
      assert_equal(false, result.awaiting_payment?)
      assert_equal(true, result.no_bids?)
      assert_equal(@auction_without_offers, result.auction)
      assert_not(result.user)
      assert_not(result.invoice)
    end
  end

  def test_result_is_created_even_after_a_user_is_deleted
    Result.destroy_all

    mock = Minitest::Mock.new
    def mock.authorized; true; end

    clazz = EisBilling::BaseController.new

    clazz.stub :authorized, mock do

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

    perform_enqueued_jobs
    assert_not(ActionMailer::Base.deliveries.empty?)
    last_email = ActionMailer::Base.deliveries.last

    assert_equal('Bid for the with-offers.test domain was unsuccessful', last_email.subject)
    assert_equal(['second_place@auction.test'], last_email.to)
  end

  def test_participants_should_receive_notifications_if_they_lose
    users_ids = @auction_with_offers.offers.pluck(:user_id)
    participants = User.where(id: users_ids)

    winner_user = @auction_with_offers.currently_winning_offer.user

    assert_equal winner_user.notifications.count, 0
    result_creator = ResultCreator.new(@auction_with_offers.id)
    result_creator.call

    perform_enqueued_jobs
    winner_user.reload

    participants.each do |participant|
      next if participant == winner_user
      assert_equal participant.notifications.count, 1
      notification = participant.notifications.first
      assert_not_equal notification.to_notification.message,
                   I18n.t('.participant_win_auction', name: @auction_with_offers.domain_name)
      assert_equal notification.to_notification.message,
                   I18n.t('.participant_lost_auction', name: @auction_with_offers.domain_name)
    end

    assert_equal winner_user.notifications.count, 1
    notification = winner_user.notifications.first
    assert_equal notification.to_notification.message,
                 I18n.t('.participant_win_auction', name: @auction_with_offers.domain_name)
    assert_not_equal notification.to_notification.message,
                 I18n.t('.participant_lost_auction', name: @auction_with_offers.domain_name)
  end

  def test_creator_emails_winner_for_auction_with_offers
    ActionMailer::Base.deliveries.clear
    result_creator = ResultCreator.new(@auction_with_offers.id)
    result_creator.call

    perform_enqueued_jobs
    assert_not(ActionMailer::Base.deliveries.empty?)
    last_email = ActionMailer::Base.deliveries.first

    assert_equal('Bid for the with-offers.test domain was successful', last_email.subject)
    assert_equal(['user@auction.test'], last_email.to)
    linkpay_text = 'You can pay for this invoice using following'
    assert CGI::unescapeHTML(last_email.body.raw_source).include? linkpay_text
  end

  def test_should_be_runned_refund_jobs
    assert_no_enqueued_jobs

    auction = auctions(:deposit_english)

    auction.ends_at = Time.zone.now + 1.day
    auction.save && auction.reload

    auction.domain_participate_auctions.destroy_all && auction.reload

    user1 = users(:participant)
    user2 = users(:second_place_participant)
    billing = billing_profiles(:orphaned)
    user2.billing_profiles << billing
    user2.save && user2.reload

    DomainParticipateAuction.create!(user: user1, auction: auction, invoice_number: '223344')
    DomainParticipateAuction.create!(user: user2, auction: auction, invoice_number: '223345')

    Offer.create!(
      auction: auction,
      user: user1,
      cents: 60_000,
      billing_profile: user1.billing_profiles.first,
      skip_if_wishlist_case: true
    )

    Offer.create!(
      auction: auction,
      user: user2,
      cents: 55_000,
      billing_profile: user2.billing_profiles.first,
      skip_if_wishlist_case: true
    )

    auction.reload
    assert_equal auction.offers.count, 2
    assert_equal auction.domain_participate_auctions.count, 2

    assert auction.in_progress?
    auction.update(ends_at: Time.zone.now - 10.seconds) && auction.reload

    auction.finished?

    clear_enqueued_jobs

    result_creator = ResultCreator.new(auction.id)
    result_creator.call

    # one of them creation results job
    assert_enqueued_jobs 4
  end
end
