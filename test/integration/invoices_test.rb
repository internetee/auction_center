require 'application_system_test_case'

class InvoicesIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:participant)
    @user_two = users(:second_place_participant)
    @auction = auctions(:valid_without_offers)
    @invoice = invoices(:payable)
    @user.reload
    sign_in @user

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def test_pay_deposit
    message = {
      oneoff_redirect_link: 'http://oneoff.redirect',
    }
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/deposit_prepayment')
      .to_return(status: 200, body: message.to_json, headers: {})

    post english_offer_deposit_auction_path(uuid: @auction.uuid), params: nil,
                                                                  headers: {}

    assert_redirected_to 'http://oneoff.redirect'
  end

  def test_banned_user_cannot_pay_deposit
    valid_from = Time.zone.now
    Ban.create!(user: @user,
                domain_name: @auction.domain_name,
                valid_from: valid_from, valid_until: valid_from + 3.days)

    @user.reload
    assert @user.banned?

    post english_offer_deposit_auction_path(uuid: @auction.uuid,
                                            current_user: @user), params: nil, headers: {}

    assert_equal I18n.t('unauthorized.banned.message'), flash[:alert].to_s
  end

  def test_completely_banned_user_cannot_pay_any_deposit
    valid_from = Time.zone.now
    3.times do
      Ban.create!(user: @user,
                  domain_name: Faker::Internet.domain_name,
                  valid_from: Time.zone.now, valid_until: valid_from + 3.days)
    end
    @user.reload
    assert @user.completely_banned?

    post english_offer_deposit_auction_path(uuid: @auction.uuid,
                                            current_user: @user), params: nil, headers: {}

    assert_equal I18n.t('unauthorized.banned.message'), flash[:alert].to_s
  end

  def test_should_send_e_invoice
    body = {
      message: 'Invoice data received',
    }
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/e_invoice/e_invoice')
      .to_return(status: :created, body: body.to_json, headers: {})

    post send_e_invoice_path(uuid: @invoice.uuid), params: nil, headers: {}

    assert_redirected_to invoice_path(@invoice.uuid)
    assert_equal 'E-Invoice was successfully sent', flash[:notice]
  end

  def test_send_e_invoice_with_billing_system_error
    body = {
      error: 'Internal server error',
    }
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/e_invoice/e_invoice')
      .to_return(status: 500, body: body.to_json, headers: {})

    post send_e_invoice_path(uuid: @invoice.uuid), params: nil, headers: {}

    assert_redirected_to invoice_path(@invoice.uuid)
    assert_equal body[:error], flash[:alert]
  end
end
