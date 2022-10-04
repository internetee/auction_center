require 'application_system_test_case'

class AdminAuctionsTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  def setup
    super

    @user = users(:administrator)
    @auction = auctions(:valid_with_offers)
    @auction_without_offers = auctions(:valid_without_offers)
    @expired_auction = auctions(:expired)
    @orphaned_auction = auctions(:orphaned)
    @english_auction = auctions(:english)
    @english_nil_starts = auctions(:english_nil_starts)

    sign_in(@user)
  end

  def teardown
    super

    travel_back
  end

  def test_numbers_have_a_span_class_in_show_view
    visit(admin_auction_path(@orphaned_auction.id))

    assert(span_element = page.find('span.number-in-domain-name'))
    assert_equal('123', span_element.text)
  end

  def test_page_has_result_link
    visit(admin_auction_path(@expired_auction))
    assert(page.has_link?('Result', href: admin_result_path(@expired_auction.result)))

    visit(admin_auction_path(@auction))
    assert_not(page.has_link?('Result', href: %r{admin/results/}))
  end

  def test_creating_auction_with_ends_at_time_earlier_than_starts_at_fails
    visit(new_admin_auction_path)

    fill_in('auction[domain_name]', with: 'new-domain-auction.test')
    fill_in('auction[starts_at]', with: Time.zone.now + 2.days)
    fill_in('auction[ends_at]', with: (Time.zone.now + 1.day))

    assert_no_changes('Auction.count') do
      click_link_or_button('Submit')
    end
  end

  def test_administrator_can_see_all_created_auctions
    travel_to Time.parse('2010-07-04 10:30 +0000').in_time_zone

    visit(admin_auctions_path)

    assert(page.has_table?('auctions-table'))
    assert(page.has_link?('with-offers.test', href: admin_auction_path(@auction.id)))
    assert(page.has_link?('no-offers.test', href: admin_auction_path(@auction_without_offers.id)))

    assert @expired_auction.finished?
    assert(page.has_no_link?('expired.test', href: admin_auction_path(@expired_auction.id)))

    prices = page.find_all('.auction-highest-offer').map(&:text)
    assert_equal(['50.00', '10.00', 'NaN', '100.00'].to_set, prices.to_set)

    offers_count = page.find_all('.auction-offers-count').map(&:text)
    assert_equal(%w[2 1 0 1].to_set, offers_count.to_set)
  end

  def test_administrator_can_remove_auction_if_it_has_not_started
    travel_to Time.parse('2010-07-04 10:30 +0000').in_time_zone

    visit(admin_auction_path(@auction))

    assert(page.has_link?('Delete'))

    accept_confirm do
      click_link_or_button('Delete')
    end

    assert(page.has_text?('Deleted successfully'))
  end

  def test_administrator_can_remove_auction_if_does_not_have_any_offers
    travel_to Time.parse('2010-07-04 10:30 +0000').in_time_zone

    visit(admin_auction_path(@auction_without_offers))

    assert(page.has_link?('Delete'))

    accept_confirm do
      click_link_or_button('Delete')
    end

    assert(page.has_text?('Deleted successfully'))
  end

  def test_auction_details_contain_a_list_of_offers
    visit(admin_auction_path(@auction))

    assert(page.has_table?('auctions-offers-table'))

    within('tbody#offers-table-body') do
      assert_text('50.00 €')
      assert_text('Joe John Participant')
    end
  end

  def test_administrator_cannot_remove_auction_if_it_has_started
    travel_to Time.parse('2010-07-05 11:30 +0000').in_time_zone

    visit(admin_auction_path(@auction))

    assert(page.has_link?('Delete'))
    assert_no_changes('Auction.count') do
      accept_confirm do
        click_link_or_button('Delete')
      end
    end

    assert_not(page.has_text?('Deleted successfully'))
  end

  def test_set_starts_at_to_english_auction
    visit admin_auctions_path
    english_auction = auctions(:english_nil_starts)

    find(:id, "auction_elements_auction_ids_#{english_auction.id}").set(true)
    fill_in "auction_elements_set_starts_at", with: Time.zone.now.to_date
    fill_in "auction_elements_set_ends_at", with: Time.zone.now.to_date + 1.day

    find(:id, "bulk-operation", match: :first).click
    assert_text "New value was set"
  end

  def test_cannot_to_change_value_of_auction_if_it_already_in_game
    visit admin_auctions_path
    english_auction = auctions(:english_nil_starts)

    find(:id, "auction_elements_auction_ids_#{english_auction.id}").set(true)
    fill_in "auction_elements_set_starts_at", with: Time.zone.now.to_date
    fill_in "auction_elements_set_ends_at", with: Time.zone.now.to_date + 1.day
    find(:id, "bulk-operation", match: :first).click

    find(:id, "auction_elements_auction_ids_#{english_auction.id}").set(true)
    fill_in "auction_elements_set_starts_at", with: Time.zone.now.to_date + 1.day
    fill_in "auction_elements_set_ends_at", with: Time.zone.now.to_date + 2.day
    find(:id, "bulk-operation", match: :first).click

    assert_text "These auctions were skipped: #{english_auction.domain_name}"
  end

  def test_should_show_all_domain_with_nil_starts_at
    travel_to Time.parse('2010-07-05 11:30 +0000').in_time_zone

    visit admin_auctions_path

    assert(page.has_text?(@auction.domain_name))
    assert(page.has_text?(@auction_without_offers.domain_name))
    assert(page.has_text?(@english_nil_starts.domain_name))

    check 'starts_at_nil', visible: false

    assert(page.has_no_text?(@auction.domain_name))
    assert(page.has_no_text?(@auction_without_offers.domain_name))
    assert(page.has_text?(@english_nil_starts.domain_name))
  end

  def test_should_set_value_for_english_auction
    visit admin_auctions_path
    find(:id, "auction_elements_auction_ids_#{@english_nil_starts.id}").set(true)

    start_date = Time.zone.now.to_date
    end_date = Time.zone.now.to_date + 1.day
    starting_price = 10.0
    slipping_end = 30

    fill_in "auction_elements_set_starts_at", with: start_date
    fill_in "auction_elements_set_ends_at", with: end_date
    fill_in "auction_elements_starting_price", with: starting_price
    fill_in "auction_elements_slipping_end", with: slipping_end
    find(:id, "bulk-operation", match: :first).click

    assert_text "New value was set"

    assert(page.has_text?(@english_nil_starts.domain_name))
    assert(page.has_text?(start_date))
    assert(page.has_text?(end_date))
    assert(page.has_text?(starting_price))
    assert(page.has_text?(slipping_end))
  end

  def test_possible_to_change_value_if_game_not_start_yet
    @english_auction.update(starts_at: Time.zone.now + 1.day, ends_at: Time.zone.now + 2.day)
    @english_auction.reload

    visit admin_auctions_path

    check "auction_elements_auction_ids_#{@english_auction.id}", visible: false

    start_date = Time.zone.now.to_date
    end_date = Time.zone.now.to_date + 1.day
    starting_price = 10.0
    slipping_end = 30

    fill_in "auction_elements_set_starts_at", with: start_date
    fill_in "auction_elements_set_ends_at", with: end_date
    fill_in "auction_elements_starting_price", with: starting_price
    fill_in "auction_elements_slipping_end", with: slipping_end
    find(:id, "bulk-operation", match: :first).click

    @english_auction.reload

    assert_text "New value was set"

    assert(page.has_text?(@english_auction.domain_name))
    assert(page.has_text?(start_date))
    assert(page.has_text?(end_date))
    assert(page.has_text?(starting_price))
    assert(page.has_text?(slipping_end))
  end
end
