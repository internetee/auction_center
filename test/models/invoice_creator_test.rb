require 'test_helper'

class InvoiceCreatorTest < ActiveSupport::TestCase
  def setup
    super

    @result = results(:expired_participant)
    @result_without_offer = results(:without_offers_nobody)
    @offer = offers(:expired_offer)

    @billing_company = billing_profiles(:company)

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

    stub_request(:patch, 'http://eis_billing_system:3000/api/v1/invoice/update_invoice_data')
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
    assert_equal result.invoice.cents, offer_bid_value
  end

  def test_private_user_should_be_able_to_pay_only_vat_if_he_made_bit_the_same_as_deposit
    deposit_value = 50_000
    offer_bid_value = 50_000

    user = users(:participant)
    auction = auctions(:english)

    auction.update(enable_deposit: true, requirement_deposit_in_cents: deposit_value, ends_at: Time.zone.now + 10.minutes)
    auction.reload
    assert auction.offers.empty?
    assert auction.enable_deposit?

    DomainParticipateAuction.create(user_id: user.id, auction_id: auction.id)
    auction.reload
    user.reload

    private_billing_profile = user.billing_profiles.last
    private_billing_profile.update(country_code: 'EE' ) && private_billing_profile.reload

    Offer.create!(
      auction: auction,
      user: user,
      cents: offer_bid_value,
      billing_profile: private_billing_profile
    )

    assert auction.offers.present?
    auction.update(ends_at: Time.zone.now - 1.minute) && auction.reload

    ResultCreationJob.perform_now
    auction.reload

    result = Result.last
    assert_equal result.auction.domain_name, auction.domain_name
    assert_equal result.invoice.cents, result.auction.offers.last.cents
    assert_equal result.invoice.status, 'issued'
  end

  def test_org_user_must_have_automaticly_paid_invoice_if_he_made_bid_as_deposit
    deposit_value = 50_000
    offer_bid_value = 50_000

    user = users(:participant)
    auction = auctions(:english)

    auction.update(enable_deposit: true, requirement_deposit_in_cents: deposit_value, ends_at: Time.zone.now + 10.minutes)
    auction.reload
    assert auction.offers.empty?
    assert auction.enable_deposit?

    user.billing_profiles << @billing_company

    DomainParticipateAuction.create(user_id: user.id, auction_id: auction.id)
    auction.reload && user.reload

    Offer.create!(
      auction: auction,
      user: user,
      cents: offer_bid_value,
      billing_profile: @billing_company
    )

    assert auction.offers.present?
    auction.update(ends_at: Time.zone.now - 1.minute) && auction.reload

    ResultCreationJob.perform_now
    auction.reload

    result = Result.last
    assert_equal result.auction.domain_name, auction.domain_name
    assert result.invoice.total.zero?
    assert_equal result.invoice.status, 'paid'
  end

  def test_should_be_added_one_more_day_for_invoice_due_date_if_auction_is_english
    offer_bid_value = 10_000

    user = users(:participant)
    auction = auctions(:english)

    mid_day = Time.new(Time.now.year, Time.now.month, Time.now.day, 12, 0, 0)
    auction.update(starts_at: mid_day - 1.day, ends_at: Time.zone.now  + 10.minutes)
    auction.reload
    assert auction.offers.empty?

    user.billing_profiles << @billing_company

    Offer.create!(
      auction: auction,
      user: user,
      cents: offer_bid_value,
      billing_profile: @billing_company
    )

    assert auction.offers.present?
    auction.update(ends_at: Time.zone.now - 1.minute) && auction.reload

    ResultCreationJob.perform_now
    auction.reload

    result = Result.last
    assert_equal result.auction.domain_name, auction.domain_name
    assert_equal result.invoice.status, 'issued'

    assert_equal result.invoice.due_date, Time.zone.today + Setting.find_by(code: 'payment_term').retrieve + 1.day
  end

  def test_should_be_assigned_billing_profile_information
    offer_bid_value = 10_000

    user = users(:participant)
    auction = auctions(:english)

    mid_day = Time.new(Time.now.year, Time.now.month, Time.now.day, 12, 0, 0)
    auction.update(starts_at: mid_day - 1.day, ends_at: Time.zone.now  + 10.minutes)
    auction.reload
    assert auction.offers.empty?

    user.billing_profiles << @billing_company

    Offer.create!(
      auction: auction,
      user: user,
      cents: offer_bid_value,
      billing_profile: @billing_company
    )

    assert auction.offers.present?
    auction.update(ends_at: Time.zone.now - 1.minute) && auction.reload

    ResultCreationJob.perform_now
    auction.reload

    result = Result.last
    assert_equal result.auction.domain_name, auction.domain_name
    assert_equal result.invoice.status, 'issued'

    assert_equal result.invoice.billing_name, @billing_company.name
    assert_equal result.invoice.billing_address, @billing_company.address
    assert_equal result.invoice.billing_vat_code, @billing_company.vat_code
    assert_equal result.invoice.billing_alpha_two_country_code, @billing_company.country_code
  end

  def test_should_be_assigned_estonian_vat_rate
    offer_bid_value = 10_000

    user = users(:participant)
    auction = auctions(:english)

    mid_day = Time.new(Time.now.year, Time.now.month, Time.now.day, 12, 0, 0)
    auction.update(starts_at: mid_day - 1.day, ends_at: Time.zone.now  + 10.minutes)
    auction.reload
    assert auction.offers.empty?

    billing_profile = user.billing_profiles.first
    billing_profile.update!(country_code: 'EE', alpha_two_country_code: 'EE', vat_code: 'IE6388047V') && billing_profile.reload
  
    Offer.create!(
      auction: auction,
      user: user,
      cents: offer_bid_value,
      billing_profile: billing_profile
    )

    assert auction.offers.present?
    auction.update(ends_at: Time.zone.now - 1.minute) && auction.reload

    ResultCreationJob.perform_now
    auction.reload

    result = Result.last
    assert_equal result.auction.domain_name, auction.domain_name
    assert_equal result.invoice.status, 'issued'

    assert_equal billing_profile.country_code, 'EE'
    assert_equal result.invoice.billing_vat_code, billing_profile.vat_code
    assert_equal result.invoice.billing_alpha_two_country_code, billing_profile.country_code
  
    assert_equal result.invoice.vat_rate, BigDecimal(Setting.find_by(code: :estonian_vat_rate).retrieve, 2)
    assert_equal result.invoice.vat_rate, 0.22
  end
end
