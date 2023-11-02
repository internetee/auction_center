require 'application_system_test_case'

class EnglishOffersTest < ApplicationSystemTestCase
  def setup
    stub_request(:any, /eis_billing_system/)
      .to_return(status: 200, body: "{\"reference_number\":\"12332\"}", headers: {})
    
    @english = auctions(:english)
    @english_nil = auctions(:english_nil_starts)

    @user = users(:participant)
    @user_two = users(:second_place_participant)

    travel_to Time.parse('2010-07-05 10:31 +0000').in_time_zone
  end

  def teardown
    super

    travel_back
  end

  def test_possible_to_make_offer
    sign_in(@user)
    visit auction_path(@english.uuid)

    assert(page.has_link?('Bid'))
    click_link('Bid')

    fill_in('offer[price]', with: '52.12')
    find('#bid_action').click

    # assert(page.has_css?('div.notice', text: 'Offer submitted successfully.'))
  end

  def test_user_cannot_to_make_bid_what_less_than_minimum_bid
    bid = rand(51.0...999.9).round(2)
    min_next_bid = calculate_min_bid(bid)
    sign_in(@user)
    visit auction_path(@english.uuid)

    assert(page.has_link?('Bid'))
    click_link('Bid')

    fill_in('offer[price]', with: bid)
    find('#bid_action').click

    @english.reload

    # assert(page.has_css?('div.notice', text: 'Offer submitted successfully.'))
    # assert find('#mini').has_text?(min_next_bid)

    fill_in('offer[price]', with: min_next_bid - 0.01)
    find('#bid_action').click

    # assert(page.has_css?('div.alert', text: "Bid failed, current price is #{bid}"))
  end

  def test_one_player_can_overbid_another_one
    Recaptcha.configuration.skip_verify_env.push('test')

    Autobider.destroy_all

    @english.offers.destroy_all
    @english.reload

    sign_in(@user)
    visit auction_path(@english.uuid)

    assert(page.has_link?('Bid'))
    click_link('Bid')

    fill_in('offer[price]', with: '5.8')
    find('#bid_action').click

    @english.reload
    current_price = Money.new(@english.highest_price)

    # assert(page.has_css?('div.notice', text: 'Offer submitted successfully.'))
    assert_equal current_price.to_f, 5.8

    sign_out(@user)
    sign_in(@user_two)

    visit auction_path(@english.uuid)
    assert(page.has_link?('Bid'))
    click_link('Bid')

    fill_in('offer[price]', with: '6.8')
    find('#bid_action').click

    @english.reload
    current_price = Money.new(@english.highest_price)

    assert(page.has_css?('div.notice', text: 'Offer submitted successfully.'))
    assert_equal current_price.to_f, 6.8
  end

  def calculate_min_bid(bid)
    update_value = 0.01

    if bid < 1.0
      update_value
    elsif bid >= 1.0 && bid < 10.0
      update_value = update_value * 10
    elsif bid >= 10.0 && bid < 100.0
      update_value = update_value * 100
    elsif bid >= 100.0 && bid < 1000.0
      update_value = update_value * 1000
    elsif bid >= 1000.0 && bid < 10000.0
      update_value = update_value * 10000
    elsif bid >= 10000.0 && bid < 100000.0
      update_value = update_value * 100000
    end

    bid + update_value
  end
end
