require 'test_helper'

class WishlistJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000')
    @auction = auctions(:valid_without_offers)
    @user = users(:participant)
  end

  def teardown
    super

    travel_back
    clear_email_deliveries
  end

  def test_it_sends_emails_when_there_is_a_wishlist_item
    WishlistItem.create!(user: @user, domain_name: @auction.domain_name)

    assert_enqueued_emails(1) do
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


  def test_wait_time
    assert_equal(1.minute, WishlistJob.wait_time)
    mock = MiniTest::Mock.new
    mock.expect(:production?, true)

    Rails.stub(:env, mock) do
      assert_equal(2.hours, WishlistJob.wait_time)
    end
  end
end
