require 'test_helper'

class DailyBroadcastAuctionsJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper
  def setup
    super

    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/reference_number_generator").
      to_return(status: 200, body: "{\"reference_number\":\"12332\"}", headers: {})

    @participant = users(:participant)
    @participant.update!(daily_summary: true)
    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def teardown
    super

    travel_back
    clear_email_deliveries
  end

  def test_includes_only_relevant_auctions
    perform_enqueued_jobs do
      DailyBroadcastAuctionsJob.perform_now
    end

    email = ActionMailer::Base.deliveries.last
    assert_not_includes(email.body, 'expired.test')

  end
end
