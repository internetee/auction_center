require 'test_helper'

class DomainRegistrationReminderJobTest < ActiveJob::TestCase
  self.use_transactional_tests = false
  
  def setup
    super
    
    Result.where(id: results(:with_invoice).id).update_all(registration_reminder_sent_at: nil)
    
    @original_reminder_setting = Setting.find_by(code: 'domain_registration_reminder').value
    @original_daily_reminder_setting = Setting.find_by(code: 'domain_registration_daily_reminder').value
    
    @result_id = results(:with_invoice).id
    Result.where(id: @result_id).update_all(status: Result.statuses[:payment_received])
    
    clear_email_deliveries
  end

  def teardown
    super
    
    Setting.find_by(code: 'domain_registration_reminder').update_column(:value, @original_reminder_setting)
    Setting.find_by(code: 'domain_registration_daily_reminder').update_column(:value, @original_daily_reminder_setting)
    
    Result.where(id: @result_id).update_all(registration_reminder_sent_at: nil)
    
    travel_back
    clear_email_deliveries
  end

  def result
    Result.find(@result_id)
  end
  
  def update_result(attributes)
    Result.where(id: @result_id).update_all(attributes)
  end

  def test_reminders_are_sent_on_5th_day_before_registration_deadline
    five_days_before = result.registration_due_date - 5
    travel_to five_days_before

    DomainRegistrationReminderJob.perform_now

    sent_at = Result.find(@result_id).registration_reminder_sent_at&.to_date
    assert_equal(five_days_before.to_date, sent_at)
  end

  def test_reminders_are_sent_on_registration_deadline
    sent_date = result.registration_due_date
    travel_to sent_date

    assert(DomainRegistrationReminderJob.needs_to_run?)

    DomainRegistrationReminderJob.perform_now

    sent_at = Result.find(@result_id).registration_reminder_sent_at&.to_date
    assert_equal(sent_date.to_date, sent_at)
  end

  def test_reminders_are_not_sent_multiple_times
    five_days_before = result.registration_due_date - 5
    three_days_before = result.registration_due_date - 3
    
    update_result(registration_reminder_sent_at: five_days_before)
    
    travel_to three_days_before

    DomainRegistrationReminderJob.perform_now

    sent_at = Result.find(@result_id).registration_reminder_sent_at&.to_date
    assert_not_equal(three_days_before.to_date, sent_at)
    assert_equal(five_days_before.to_date, sent_at)
  end

  def test_reminders_are_not_sent_for_results_with_no_bids
    update_result(status: Result.statuses[:no_bids])

    three_days_before = result.registration_due_date - 3
    travel_to three_days_before

    DomainRegistrationReminderJob.perform_now

    sent_at = Result.find(@result_id).registration_reminder_sent_at
    assert_nil(sent_at)
  end

  def test_reminders_are_not_sent_after_domain_is_registered
    update_result(status: Result.statuses[:domain_registered])

    three_days_before = result.registration_due_date - 3
    travel_to three_days_before

    DomainRegistrationReminderJob.perform_now

    sent_at = Result.find(@result_id).registration_reminder_sent_at
    assert_nil(sent_at)
  end

  def test_reminders_are_not_sent_after_domain_has_not_been_registered
    update_result(status: Result.statuses[:domain_not_registered])

    three_days_before = result.registration_due_date - 3
    travel_to three_days_before

    DomainRegistrationReminderJob.perform_now

    sent_at = Result.find(@result_id).registration_reminder_sent_at
    assert_nil(sent_at)
  end

  def test_time_is_configurable_via_setting
    Setting.find_by(code: 'domain_registration_reminder').update_column(:value, 2)

    three_days_before = result.registration_due_date - 3
    travel_to three_days_before

    DomainRegistrationReminderJob.perform_now

    sent_at = Result.find(@result_id).registration_reminder_sent_at
    assert_nil(sent_at)
  end

  def test_mail_is_not_sent_between_threshold_dates
    Setting.find_by(code: 'domain_registration_reminder').update_column(:value, 6)
    Setting.find_by(code: 'domain_registration_daily_reminder').update_column(:value, 3)

    update_result(registration_reminder_sent_at: result.registration_due_date - 6)

    four_days_before = result.registration_due_date - 4
    travel_to four_days_before

    DomainRegistrationReminderJob.perform_now

    sent_at = Result.find(@result_id).registration_reminder_sent_at&.to_date
    assert_not_equal(four_days_before.to_date, sent_at)
  end

  def test_mail_is_not_sent_after_dates
    Setting.find_by(code: 'domain_registration_reminder').update_column(:value, 6)
    Setting.find_by(code: 'domain_registration_daily_reminder').update_column(:value, 3)

    seven_days_after = result.registration_due_date + 7
    travel_to seven_days_after

    DomainRegistrationReminderJob.perform_now

    sent_at = Result.find(@result_id).registration_reminder_sent_at
    assert_nil(sent_at)
  end

  def test_mail_is_not_sent_before_dates
    Setting.find_by(code: 'domain_registration_reminder').update_column(:value, 6)
    Setting.find_by(code: 'domain_registration_daily_reminder').update_column(:value, 3)

    eight_days_before = result.registration_due_date - 8
    travel_to eight_days_before

    DomainRegistrationReminderJob.perform_now

    sent_at = Result.find(@result_id).registration_reminder_sent_at
    assert_nil(sent_at)
  end

  def test_mail_is_sent_later_if_first_sending_fails
    Setting.find_by(code: 'domain_registration_reminder').update_column(:value, 6)
    Setting.find_by(code: 'domain_registration_daily_reminder').update_column(:value, 3)

    five_days_before = result.registration_due_date - 5
    travel_to five_days_before

    DomainRegistrationReminderJob.perform_now

    sent_at = Result.find(@result_id).registration_reminder_sent_at&.to_date
    assert_equal(five_days_before.to_date, sent_at)
  end

  def test_multiple_reminders_sent_if_everyday_remind
    Setting.find_by(code: 'domain_registration_daily_reminder').update_column(:value, 5)

    five_days_before = result.registration_due_date - 5
    three_days_before = result.registration_due_date - 3

    update_result(registration_reminder_sent_at: nil)
    
    travel_to five_days_before
    DomainRegistrationReminderJob.perform_now
    
    sent_at = Result.find(@result_id).registration_reminder_sent_at&.to_date
    assert_equal(five_days_before.to_date, sent_at)

    travel_to three_days_before
    DomainRegistrationReminderJob.perform_now

    sent_at = Result.find(@result_id).registration_reminder_sent_at&.to_date
    assert_equal(three_days_before.to_date, sent_at)
  end
end
