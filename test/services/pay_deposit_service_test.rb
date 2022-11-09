require 'test_helper'

class PayDepositServiceTest < ActiveSupport::TestCase
  setup do
    Spy.on_instance_method(EisBilling::BaseController, :authorized).and_return(true)
    @invoice = invoices(:payable)
    @auction = auctions(:english)
    @user = users(:participant)
  end

  def test_should_get_oneoff_link
    message = {
      oneoff_redirect_link: 'http://oneoff.redirect'
    }
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/deposit_prepayment')
      .to_return(status: 200, body: message.to_json, headers: {})

    res = EisBilling::PayDepositService.call(
      amount: 500.0,
      customer_url: 'https://auction.callback',
      description: 'deposit_prepayment'
    )

    assert_equal res.instance['oneoff_redirect_link'], 'http://oneoff.redirect'
  end
end
