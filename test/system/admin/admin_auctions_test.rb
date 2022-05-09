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

    sign_in(@user)
  end

  def teardown
    super

    travel_back
  end

  def test_administrator_can_create_new_auction
    visit(new_admin_auction_path)

    fill_in('auction[domain_name]', with: 'new-domain-auction.test')
    fill_in('auction[starts_at]', with: Time.zone.now + 30.minutes)
    fill_in('auction[ends_at]', with: (Time.zone.now + 1.day))

    assert_changes('Auction.count') do
      click_link_or_button('Submit')
    end
  end

  # def test_administrator_can_search_for_auctions
  #   visit(admin_auctions_path)

  #   fill_in('domain_name', with: 'w')
  #   find(:css, 'i.arrow.right.icon').click

  #   assert(page.has_link?('with-invoice.test'))
  #   assert(page.has_link?('with-offers.test'))
  #   assert(page.has_text?('Search results are limited to first 20 hits.'))
  # end

  def test_numbers_have_a_span_class_in_index_list
    visit(admin_auctions_path)

    assert(span_element = page.find('span.number-in-domain-name'))
    assert_equal('123', span_element.text)
  end

  def test_numbers_have_a_span_class_in_show_view
    visit(admin_auction_path(@orphaned_auction.id))

    assert(span_element = page.find('span.number-in-domain-name'))
    assert_equal('123', span_element.text)
  end

  # def test_administrator_can_search_by_top_level_domain
  #   visit(admin_auctions_path)

  #   fill_in('domain_name', with: 'offers.test')
  #   find(:css, 'i.arrow.right.icon').click

  #   assert(page.has_link?('with-offers.test'))
  #   assert(page.has_text?('Search results are limited to first 20 hits.'))
  # end

  def test_page_has_result_link
    visit(admin_auction_path(@expired_auction))
    assert(page.has_link?('Result', href: admin_result_path(@expired_auction.result)))

    visit(admin_auction_path(@auction))
    assert_not(page.has_link?('Result', href: %r{admin/results/}))
  end

  def test_creating_auction_with_ends_at_time_in_the_past_fails
    visit(new_admin_auction_path)

    fill_in('auction[domain_name]', with: 'new-domain-auction.test')
    fill_in('auction[starts_at]', with: Time.zone.now)
    fill_in('auction[ends_at]', with: (Time.zone.now - 1.day))

    # Check in-browser validation
    validation_message = find('#auction_ends_at').native.attribute('validationMessage')
    assert(validation_message)

    assert_no_changes('Auction.count') do
      click_link_or_button('Submit')
    end
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
    visit(admin_auctions_path)

    assert(page.has_table?('auctions-table'))
    assert(page.has_link?('with-offers.test', href: admin_auction_path(@auction.id)))
    assert(page.has_link?('no-offers.test', href: admin_auction_path(@auction_without_offers.id)))
    assert(page.has_link?('expired.test', href: admin_auction_path(@expired_auction.id)))

    prices = page.find_all('.auction-highest-offer').map(&:text)
    assert_equal(['50.00', '10.00', 'NaN', '100.00'].to_set, prices.to_set)

    offers_count = page.find_all('.auction-offers-count').map(&:text)
    assert_equal(%w[2 1 0 1].to_set, offers_count.to_set)
  end

  def test_auctions_for_domain_names_need_to_be_unique_for_its_duration
    travel_to Time.parse('2010-07-05 10:31 +0000').in_time_zone

    visit(new_admin_auction_path)

    fill_in('auction[domain_name]', with: @auction.domain_name)
    fill_in('auction[starts_at]', with: Time.zone.now)
    fill_in('auction[ends_at]', with: (Time.zone.now + 1.day))

    assert_no_changes('Auction.count') do
      click_link_or_button('Submit')
    end
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
    assert(
      page.has_text?('It is not allowed to delete an action that is already in progress and has bids or has already finished.')
    )
  end

  def test_search_existing_auction_without_submitting
    visit admin_auctions_path

    auction = auctions(:valid_with_offers)
    fill_in 'domain_name', :with => auction.domain_name

    assert_text auction.domain_name
    assert_text auction.starts_at
    assert_text auction.ends_at
  end

  # def test_should_filtering_english_auctions
  #   english_auction = auctions(:english)
  #   auction_blind = auctions(:valid_with_offers)
  #   visit admin_auctions_path

  #   select "english", :from => "type"

  #   assert(page.has_text?(english_auction.domain_name))
  #   assert(page.has_text?(english_auction.starts_at))
  #   assert(page.has_text?(english_auction.ends_at))

  #   assert(page.has_no_text?(assert_no_text auction_blind.domain_name))
  # end

  # def test_should_filtering_blind_auctions
  #   english_auction = auctions(:english)
  #   auction_blind = auctions(:valid_with_offers)
  #   visit admin_auctions_path

  #   select "blind", :from => "type"

  #   assert_no_text english_auction.domain_name

  #   assert_no_text auction_blind.domain_name
  #   assert_no_text auction_blind.starts_at
  #   assert_no_text auction_blind.ends_at
  # end

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
end
