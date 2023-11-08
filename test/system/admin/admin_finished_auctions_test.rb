require 'application_system_test_case'

class AdminFinishedAuctionsTest < ApplicationSystemTestCase
  # def setup
  #   super

  #   @administrator = users(:administrator)
  #   @expired_auction = auctions(:expired)
  #   @with_invoice_auction = auctions(:with_invoice)

  #   travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  #   sign_in(@administrator)

  #   @original_wait_time = Capybara.default_max_wait_time
  #   Capybara.default_max_wait_time = 10
  # end

  # def teardown
  #   super

  #   Capybara.default_max_wait_time = @original_wait_time
  #   travel_back
  # end

  # def test_should_display_finished_auctions
  #   visit admin_finished_auctions_index_path

  #   within('#auctions-needing-results-table', match: :first) do
  #     assert_text(@expired_auction.domain_name)
  #     assert_text(@expired_auction.ends_at)

  #     assert_text(@with_invoice_auction.domain_name)
  #     assert_text(@with_invoice_auction.ends_at)
  #   end
  # end

  # def test_should_display_searched_auction
  #   visit admin_finished_auctions_index_path

  #   fill_in 'domain_name', with: @expired_auction.domain_name

  #   # sleep 1

  #   within('#auctions-needing-results-table', match: :first) do
  #     assert_text(@expired_auction.domain_name)
  #     assert_text(@expired_auction.ends_at)

  #     assert_no_text(@with_invoice_auction.domain_name)
  #     assert_no_text(@with_invoice_auction.ends_at)
  #   end
  # end
end
