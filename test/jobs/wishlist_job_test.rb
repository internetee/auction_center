require 'test_helper'

class WishlistJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
    @auction = auctions(:valid_without_offers)
    @user = users(:participant)
  end

  def teardown
    super

    travel_back
    clear_email_deliveries
  end

  def test_it_sends_emails_and_only_once_when_there_is_a_wishlist_item
    WishlistItem.create!(user: @user, domain_name: @auction.domain_name)

    assert_enqueued_emails(1) do
      WishlistJob.perform_now(@auction.domain_name, @auction.remote_id)
      WishlistJob.perform_now(@auction.domain_name, @auction.remote_id)
    end
  end

  def test_it_does_not_send_an_email_when_domain_is_incorrect
    WishlistItem.create!(user: @user, domain_name: @auction.domain_name)

    assert_no_enqueued_emails do
      WishlistJob.perform_now('foo.test', @auction.remote_id)
    end
  end

  def test_it_does_not_send_an_email_when_there_is_no_active_auction
    WishlistItem.create!(user: @user, domain_name: @auction.domain_name)

    assert_no_enqueued_emails do
      WishlistJob.perform_now(@auction.domain_name, SecureRandom.uuid)
    end
  end

  def test_it_does_not_send_an_email_when_there_is_no_wishlist_item
    assert_equal(0, WishlistItem.count)

    assert_no_enqueued_emails do
      WishlistJob.perform_now(@auction.domain_name, @auction.remote_id)
    end
  end

  def test_schedules_auto_offer_job_and_only_once_when_there_is_a_wishlist_item
    WishlistItem.create!(user: @user, domain_name: @auction.domain_name)

    assert_enqueued_jobs 1, only: WishlistAutoOfferJob do
      WishlistJob.perform_now(@auction.domain_name, @auction.remote_id)
      WishlistJob.perform_now(@auction.domain_name, @auction.remote_id)
    end

    assert_enqueued_with(job: WishlistAutoOfferJob, args: [@auction.id], at: @auction.starts_at)
  end
end
