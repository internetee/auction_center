require 'test_helper'

class SummaryReportTest < ActiveSupport::TestCase
  def setup
    super

    @yesterday = Time.zone.yesterday.to_time
    @today = Time.zone.now + 60
    @tomorrow = Time.zone.tomorrow.to_time
    @summary = SummaryReport.new(@yesterday, @today)
    @user = users(:participant)
    @result = results(:expired_participant)
    @no_offers = results(:without_offers_nobody)
  end

  def test_holds_start_and_end_date
    assert_equal(@yesterday, @summary.start_time)
    assert_equal(@today, @summary.end_time)
  end

  def test_winning_offers_uses_created_at
    assert_equal([{'domain_name' => 'expired.test', 'cents' => 1000},
                  {'domain_name' => 'with-invoice.test', 'cents' => 10000},
                  {'domain_name' => 'orphaned.test', 'cents' => 1000}].to_set,
                 @summary.winning_offers.to_set)
  end

  def test_winning_offers_are_ordered_by_cents
    assert_equal({'domain_name' => 'with-invoice.test', 'cents' => 10000},
                 @summary.winning_offers.first)
  end

  def test_winning_offers_with_date_manipulation
    Result.all.update(created_at: Time.zone.today - 30)
    @result.update!(created_at: Time.zone.now - 3)

    assert_equal([{'domain_name' => 'expired.test', 'cents' => 1000}], @summary.winning_offers)
  end

  def test_results_with_no_bids
    assert_equal([{'domain_name' => 'no-offers.test',
                   'status' => 'no_bids'}],
                @summary.results_with_no_bids)
  end

  def test_registration_deadlines
    @result.update!(status: Result.statuses[:payment_received],
                   registration_due_date: Date.tomorrow)

    assert_equal([{'domain_name' => 'expired.test',
                    'email' => @user.email,
                    'mobile_phone' => @user.mobile_phone}],
                @summary.registration_deadlines)
  end

  def test_bans_returns_bans_that_started_within_the_period
    ban = Ban.create!(domain_name: "foo.test",
                user: @user,
                valid_from: @today,
                valid_until: @tomorrow)

    Ban.create!(domain_name: "not-in-the-list.test",
                user: @user,
                valid_from: @today,
                valid_until: @tomorrow,
                created_at: @yesterday)

    assert_equal([{'domain_name' => ban.domain_name,
                   'valid_until' => ban.valid_until,
                   'email' => @user.email}], @summary.bans)
  end
end
