require 'application_system_test_case'

class AdminAuctionsTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:administrator)
    @auction = auctions(:id_test)
    @expired_auction = auctions(:expired)

    sign_in(@user)
  end

  def teardown
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
    assert(page.has_link?('id.test', href: admin_auction_path(@auction.id)))
    assert(page.has_link?('expired.test', href: admin_auction_path(@expired_auction.id)))
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
