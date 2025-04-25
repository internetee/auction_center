require 'test_helper'

class DomainRegistrationReminderJobTest < ActiveJob::TestCase
  def setup
    super

    @result = results(:with_invoice)
    @result.update!(status: 'payment_received')
    clear_email_deliveries
  end

  def teardown
    super

    travel_back
    clear_email_deliveries
  end

  def test_reminders_are_sent_on_5th_day_before_registration_deadline
    five_days_before = @result.registration_due_date - 5
    travel_to five_days_before

    DomainRegistrationReminderJob.perform_now

    @result.reload
    assert_equal(five_days_before, @result.registration_reminder_sent_at)
  end

  def test_reminders_are_sent_on_registration_deadline
    sent_date = @result.registration_due_date
    travel_to sent_date

    assert(DomainRegistrationReminderJob.needs_to_run?)

    DomainRegistrationReminderJob.perform_now

    @result.reload
    assert_equal(sent_date, @result.registration_reminder_sent_at)
  end

  def test_reminders_are_not_sent_multiple_times
    five_days_before = @result.registration_due_date - 5
    three_days_before = @result.registration_due_date - 3
    travel_to three_days_before

    @result.update!(registration_reminder_sent_at: five_days_before)

    DomainRegistrationReminderJob.perform_now

    @result.reload
    assert_not_equal(three_days_before, @result.registration_reminder_sent_at.to_date)
    assert_equal(five_days_before, @result.registration_reminder_sent_at.to_date)
  end

  def test_reminders_are_not_sent_for_results_with_no_bids
    @result.update!(status: 'no_bids')

    three_days_before = @result.registration_due_date - 3
    travel_to three_days_before

    DomainRegistrationReminderJob.perform_now

    @result.reload
    assert_not(@result.registration_reminder_sent_at)
  end

  def test_reminders_are_not_sent_after_domain_is_registered
    @result.update!(status: 'domain_registered')

    three_days_before = @result.registration_due_date - 3
    travel_to three_days_before

    DomainRegistrationReminderJob.perform_now

    @result.reload
    assert_not(@result.registration_reminder_sent_at)
  end

  def test_reminders_are_not_sent_after_domain_has_not_been_registered
    @result.update!(status: 'domain_not_registered')

    three_days_before = @result.registration_due_date - 3
    travel_to three_days_before

    DomainRegistrationReminderJob.perform_now

    @result.reload
    assert_not(@result.registration_reminder_sent_at)
  end

  def test_time_is_configurable_via_setting
    setting = settings(:domain_registration_reminder)
    setting.update!(value: 2)

    three_days_before = @result.registration_due_date - 3
    travel_to three_days_before

    DomainRegistrationReminderJob.perform_now

    @result.reload
    assert_not(@result.registration_reminder_sent_at)
  end

  def test_mail_is_not_sent_between_threshold_dates
    setting = settings(:domain_registration_reminder)
    setting.update!(value: 6)
    setting = settings(:domain_registration_daily_reminder)
    setting.update!(value: 3)

    @result.update(registration_reminder_sent_at: @result.registration_due_date - 6)

    four_days_before = @result.registration_due_date - 4
    travel_to four_days_before

    DomainRegistrationReminderJob.perform_now

    @result.reload
    assert_not_equal(four_days_before, @result.registration_reminder_sent_at)
  end

  def test_mail_is_not_sent_after_dates
    setting = settings(:domain_registration_reminder)
    setting.update!(value: 6)
    setting = settings(:domain_registration_daily_reminder)
    setting.update!(value: 3)

    seven_days_after = @result.registration_due_date + 7
    travel_to seven_days_after

    DomainRegistrationReminderJob.perform_now

    @result.reload
    assert_not(@result.registration_reminder_sent_at)
  end

  def test_mail_is_not_sent_before_dates
    setting = settings(:domain_registration_reminder)
    setting.update!(value: 6)
    setting = settings(:domain_registration_daily_reminder)
    setting.update!(value: 3)

    eight_days_before = @result.registration_due_date - 8
    travel_to eight_days_before

    DomainRegistrationReminderJob.perform_now

    @result.reload
    assert_not(@result.registration_reminder_sent_at)
  end

  def test_mail_is_sent_later_if_first_sending_fails
    setting = settings(:domain_registration_reminder)
    setting.update!(value: 6)
    setting = settings(:domain_registration_daily_reminder)
    setting.update!(value: 3)

    five_days_before = @result.registration_due_date - 5
    travel_to five_days_before

    DomainRegistrationReminderJob.perform_now

    @result.reload
    assert_equal(five_days_before, @result.registration_reminder_sent_at)
  end

  def test_multiple_reminders_sent_if_everyday_remind
    set_remind_on_domain_registration_everyday_true

    five_days_before = @result.registration_due_date - 5
    three_days_before = @result.registration_due_date - 3

    travel_to five_days_before
    DomainRegistrationReminderJob.perform_now
    @result.reload
    assert_equal(five_days_before, @result.registration_reminder_sent_at)

    travel_to three_days_before
    DomainRegistrationReminderJob.perform_now

    @result.reload
    assert_equal(three_days_before, @result.registration_reminder_sent_at)
  end

  def set_remind_on_domain_registration_everyday_true
    setting = settings(:domain_registration_daily_reminder)
    setting.update!(value: '5')
  end
end
