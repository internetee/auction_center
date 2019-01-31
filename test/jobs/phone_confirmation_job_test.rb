require 'test_helper'

class PhoneConfirmationJobTest < ActiveJob::TestCase
  def setup
    super

    @confirmed_user = users(:participant)
  end

  def teardown
    super
  end

  def test_phone_confirmations_are_sent_when_required
    original_confirmation_time = @confirmed_user.mobile_phone_confirmed_at
    PhoneConfirmationJob.perform_now(@confirmed_user.id)

    @confirmed_user.reload
    assert_equal(@confirmed_user.mobile_phone_confirmed_at, original_confirmation_time)
  end
end
