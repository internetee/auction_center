require 'test_helper'
require 'support/mock_summary_report'

class AdminMailerTest < ActionMailer::TestCase
  def setup
    super

    @time = Time.parse('2010-07-05 10:30 +0000').in_time_zone
    travel_to @time

    @user = users(:administrator)
    @transaction = OpenStruct.new(amount: 10.00,
                                  currency: 'EUR',
                                  date: Time.zone.today,
                                  payment_reference_number: '2199812',
                                  payment_description: 'description 2199812')
  end

  def teardown
    super

    clear_email_deliveries
    travel_back
  end

  def test_mail_gets_delivered
    AdminMailer.transaction_mail(@transaction).deliver_now

    assert_not(ActionMailer::Base.deliveries.empty?)
    email = ActionMailer::Base.deliveries.last
    assert_equal(['administrator@auction.test'], email.to)
    assert_equal('Undefined transaction', email.subject)
  end
end
