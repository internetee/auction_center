require 'application_system_test_case'

class AutobiderControllerTest < ApplicationSystemTestCase
  def setup
    super

    @participant = users(:participant)
    @auction = auctions(:english)

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
    sign_in(@participant)

    # @original_wait_time = Capybara.default_max_wait_time
    # Capybara.default_max_wait_time = 10
  end

  # def teardown
    # super

    # Capybara.default_max_wait_time = @original_wait_time
    # travel_back
  # end

  def test_should_set_autobider_value_and_update_it
    @auction.offers.destroy_all
    @auction.reload

    visit new_auction_english_offer_path(auction_uuid: @auction.uuid)

    find(id: 'autobider-value-btn').click
    fill_in 'autobider_price', with: @auction.min_bids_step + 1
    find(id: 'autobidder_action').click

    assert_equal find('#autobider-current').text, (@auction.min_bids_step + 1).to_s

    offer = @auction.offers.last

    visit edit_english_offer_path(uuid: offer.uuid)
    find(id: 'autobider-value-btn').click
    fill_in 'autobider_price', with: @auction.min_bids_step + 6
    find(id: 'autobidder_action').click

    assert_equal find('#autobider-current').text, (@auction.min_bids_step + 6).to_s
  end
end
