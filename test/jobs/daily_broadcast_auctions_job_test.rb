require 'test_helper'

class DailyBroadcastAuctionsJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper
  def setup
    super

    @participant = users(:participant)
    @participant.update!(auction_newsletter: true)
    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone


  end

  def teardown
    super

    travel_back
    clear_email_deliveries
  end

  def test_sends_email_to_subscribers
    perform_enqueued_jobs do
      DailyBroadcastAuctionsJob.perform_now
    end

    assert_not(ActionMailer::Base.deliveries.empty?)
    email = ActionMailer::Base.deliveries.last
    assert_equal(['user@auction.test'], email.to)
    assert_equal("Today's .EE domain auction list is available!", email.subject)
    assert_includes(email.body, "with-offers.test")
  end

  def test_includes_only_relevant_auctions
    perform_enqueued_jobs do
      DailyBroadcastAuctionsJob.perform_now
    end

    email = ActionMailer::Base.deliveries.last
    assert_not_includes(email.body, "expired.test")
    
  end
end
