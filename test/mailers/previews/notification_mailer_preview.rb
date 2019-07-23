require_relative '../../support/mock_summary_report'

class NotificationMailerPreview < ActionMailer::Preview
  def daily_summary_email_english
    user = User.new(email: 'some@email.com', locale: :en)
    NotificationMailer.daily_summary_email(user, daily_summary_report)
  end

  def daily_summary_report
    summary_report = MockSummaryReport.new(Time.zone.yesterday, Time.zone.today)

    summary_report.results_with_no_bids = [
      { 'domain_name' => 'expired.test', 'status' => 'no_bids' },
      { 'domain_name' => 'not_interesting.test', 'status' => 'no_bids' },
    ]

    summary_report.winning_offers = [
      { 'domain_name' => 'expired.test', 'cents' => 1000, 'result_id' => 1 },
      { 'domain_name' => 'very-interesting.test', 'cents' => 10_000, 'result_id' => 3 },
    ]

    summary_report.registration_deadlines = [
      { 'domain_name' => 'expired.test', 'email' => 'foo@bar.baz', 'mobile_phone' => nil,
        'result_id' => 3 },
      { 'domain_name' => 'other.test', 'email' => 'foo@bar.baz', 'mobile_phone' => '+37255556666',
        'result_id' => 4 },
    ]

    summary_report.bans = [
      { 'domain_name' => 'expired.test', 'valid_until' => Date.today, 'email' => 'foo@bar.baz' },
      { 'domain_name' => nil, 'valid_until' => Date.today, 'email' => 'foo@bar.baz' },
    ]

    summary_report
  end
end
