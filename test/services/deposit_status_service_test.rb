require 'test_helper'

class DepositStatusServiceTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @auction = auctions(:english)
    @user = users(:participant)
    Spy.on_instance_method(EisBilling::BaseController, :authorized).and_return(true)
  end

  def test_call_fetches_data_from_billing_system
    message = {"message": "Status updated"}
    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/deposit_status")
      .to_return(status: 200, body: message.to_json, headers: {})

    d = DomainParticipateAuction.create(user_id: @user.id, auction_id: @auction.id)
    d.update(status: 'returned')

    res = d.send_deposit_status_to_billing_system

    assert res.result?
  end

  def test_return_errors_in_struct_format
    message = {"error": "Shit happens"}
    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/deposit_status")
      .to_return(status: 422, body: message.to_json, headers: {})

    d = DomainParticipateAuction.create(user_id: @user.id, auction_id: @auction.id)
    d.update(status: 'returned')

    res = d.send_deposit_status_to_billing_system

    refute res.result?
    assert_equal res.errors, "Shit happens"
  end
end
