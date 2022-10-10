require 'application_system_test_case'

class InvoicesIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:participant)
    @user_two = users(:second_place_participant)
    @auction = auctions(:valid_without_offers)
    @user.reload
    sign_in @user

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def test_pay_deposit
    message = {
      oneoff_redirect_link: 'http://oneoff.redirect'
    }
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/deposit_prepayment')
      .to_return(status: 200, body: message.to_json, headers: {})

    post english_offer_deposit_auction_path(uuid: @auction.uuid),
                                            params: nil,
                                            headers: {}

    assert_redirected_to 'http://oneoff.redirect'
  end
end
