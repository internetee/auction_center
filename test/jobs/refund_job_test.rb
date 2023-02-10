require 'test_helper'

class RefundJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper 

  def setup
    super

    @confirmed_user = users(:participant)
    @success = {
      "message" => 'Invoice was refunded'
    }

    @failed = {
      "error" => {
        "code" => 4037,
        "message" => "Open banking payments cannot be refunded"
      }
    }

    @base_url = AuctionCenter::Application.config
      .customization[:billing_system_integration]
      &.compact&.fetch(:eis_billing_system_base_url, '')
    @endpoint = '/api/v1/refund/auction'
    @domain_participate_auction = domain_participate_auctions(:one)

    ActionMailer::Base.deliveries.clear
  end

  def teardown
    super
  end

  def test_it_should_receive_successful_response
    stub_request(:post, "#{@base_url}#{@endpoint}")
      .to_return(status: 200, body: @success.to_json, headers: {})

    assert_equal @domain_participate_auction.status, 'paid'
    r = RefundJob.perform_now(@domain_participate_auction.id, @domain_participate_auction.invoice_number)
    @domain_participate_auction.reload

    assert_equal @domain_participate_auction.status, 'returned'
    assert_equal r['message'], 'Invoice was refunded'

    assert_enqueued_emails 0
  end

  def test_it_should_inform_admin_if_something_when_wrong
    stub_request(:post, "#{@base_url}#{@endpoint}")
    .to_return(status: 422, body: @failed.to_json, headers: {})

    assert_equal @domain_participate_auction.status, 'paid'
    r = RefundJob.perform_now(@domain_participate_auction.id, @domain_participate_auction.invoice_number)
    @domain_participate_auction.reload

    assert_equal @domain_participate_auction.status, 'paid'
    assert_equal r['error']['message'], 'Open banking payments cannot be refunded'

    assert_enqueued_emails 1
  end
end
