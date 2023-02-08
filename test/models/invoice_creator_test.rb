require 'test_helper'

class InvoiceCreatorTest < ActiveSupport::TestCase
  def setup
    super

    @result = results(:expired_participant)
    @result_without_offer = results(:without_offers_nobody)
    @offer = offers(:expired_offer)

    invoice_n = Invoice.order(number: :desc).last.number
    @invoice_number = {
      invoice_number: invoice_n + 3,
      date: Time.zone.now-10.minutes
    }
    @invoice_link = {
      everypay_link: "http://link.test"
    }

    @message = {
      message: 'ok'
    }

    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_number_generator")
      .to_return(status: 200, body: @invoice_number.to_json, headers: {})

    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_generator")
      .to_return(status: 200, body: @invoice_link.to_json, headers: {})

    stub_request(:put, "http://registry:3000/eis_billing/e_invoice_response").
      to_return(status: 200, body: @invoice_number.to_json, headers: {})

    stub_request(:post, "http://eis_billing_system:3000/api/v1/e_invoice/e_invoice").
      to_return(status: 200, body: "", headers: {})

    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/oneoff')
        .to_return(status: 200, body: @message.to_json, headers: {})
  end

  def test_an_invoice_is_prefilled_with_data_from_winning_offer
    mock = Minitest::Mock.new
    def mock.authorized; true; end

    clazz = EisBilling::BaseController.new

    clazz.stub :authorized, mock do
      invoice_creator = InvoiceCreator.new(@result.id)
      invoice = invoice_creator.call

      assert(invoice.is_a?(Invoice))
      assert_equal(@result, invoice.result)
      assert_equal(@result.user, invoice.user)
      assert_equal(@offer.price, invoice.price)
    end
  end

  def test_return_early_if_result_does_not_exist
    invoice_creator = InvoiceCreator.new(:foo)
    invoice = invoice_creator.call

    assert_nil(invoice)
  end

  def test_returns_early_if_result_does_not_have_a_winning_offer
    invoice_creator = InvoiceCreator.new(@result_without_offer)
    invoice = invoice_creator.call

    assert_nil(invoice)
  end

  def test_invoice_creator_also_creates_invoice_items
    mock = Minitest::Mock.new
    def mock.authorized; true; end

    clazz = EisBilling::BaseController.new

    clazz.stub :authorized, mock do
      invoice_creator = InvoiceCreator.new(@result.id)
      invoice = invoice_creator.call

      assert(invoice.is_a?(Invoice))
      assert(invoice.items)

      assert_equal('expired.test (auction 1999-07-05) registration code', invoice.items.first.name)
    end
  end

  def test_if_deposit_include_should_gerentate_balance_invoice
    deposit_value = 50_000
    offer_bid_value = 70_000

    user = users(:participant)
    auction = auctions(:english)

    auction.update(enable_deposit: true, requirement_deposit_in_cents: deposit_value, ends_at: Time.zone.now + 10.minutes)
    auction.reload
    assert auction.offers.empty?
    assert auction.enable_deposit?

    DomainParticipateAuction.create(user_id: user.id, auction_id: auction.id)
    auction.reload
    user.reload

    Offer.create!(
      auction: auction,
      user: user,
      cents: offer_bid_value,
      billing_profile: user.billing_profiles.first
    )

    assert auction.offers.present?
    auction.update(ends_at: Time.zone.now - 1.minute) && auction.reload

    ResultCreationJob.perform_now
    auction.reload

    result = Result.last
    assert_equal result.auction.domain_name, auction.domain_name
    assert_equal result.invoice.cents, offer_bid_value - deposit_value
  end
end
