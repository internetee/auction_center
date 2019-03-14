# encoding: UTF-8

require 'application_system_test_case'

class AdminAuctionsTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  def setup
    super

    @user = users(:administrator)
    @auction = auctions(:valid_with_offers)
    @auction_without_offers = auctions(:valid_without_offers)
    @expired_auction = auctions(:expired)

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

  def test_page_has_result_link
    visit(admin_auction_path(@expired_auction))
    assert(page.has_link?('Result', href: admin_result_path(@expired_auction.result)))

    visit(admin_auction_path(@auction))
    refute(page.has_link?('Result', href: /admin\/results\//))
  end

  def test_creating_auction_with_ends_at_time_in_the_past_fails
   visit(new_admin_auction_path)

    fill_in('auction[domain_name]', with: 'new-domain-auction.test')
    fill_in('auction[starts_at]', with: Time.zone.now)
    fill_in('auction[ends_at]', with: (Time.zone.now - 1.day))

    # Check in-browser validation
    validation_message = find("#auction_ends_at").native.attribute("validationMessage")
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
    assert_equal(['50.00', '10.00', '', '100.00'].to_set, prices.to_set)

    offers_count = page.find_all('.auction-offers-count').map(&:text)
    assert_equal(['2', '1', '0', '1'].to_set, offers_count.to_set)
  end

  def test_auctions_for_domain_names_need_to_be_unique_for_its_duration
    travel_to Time.parse('2010-07-05 10:31 +0000')

    visit(new_admin_auction_path)

    fill_in('auction[domain_name]', with: @auction.domain_name)
    fill_in('auction[starts_at]', with: Time.zone.now)
    fill_in('auction[ends_at]', with: (Time.zone.now + 1.day))

    assert_no_changes('Auction.count') do
      click_link_or_button('Submit')
    end
  end

  def test_administrator_can_remove_auction_if_it_has_not_started
    travel_to Time.parse('2010-07-04 10:30 +0000')

    visit(admin_auction_path(@auction))

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
    travel_to Time.parse('2010-07-05 11:30 +0000')

    visit(admin_auction_path(@auction))

    assert(page.has_link?('Delete'))

    assert_no_changes('Auction.count') do
      accept_confirm do
        click_link_or_button('Delete')
      end
    end

    refute(page.has_text?('Deleted successfully'))
    assert(
      page.has_text?('You cannot delete an auction that is already in progress or has finished.')
    )
  end
end
