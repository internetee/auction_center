require 'application_system_test_case'

class AdminAuctionsTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:administrator)
    @auction = auctions(:id_test)
    @expired_auction = auctions(:expired)

    sign_in(@user)
  end

  def test_administrator_can_create_new_auction
    visit(new_admin_auction_path)

    fill_in('auction[domain_name]', with: 'new-domain-auction.test')
    fill_in('auction[starts_at]', with: Time.zone.now)
    fill_in('auction[ends_at]', with: (Time.zone.now + 1.day))

    assert_changes('Auction.count') do
      click_link_or_button('Submit')
    end
  end

  def test_administrator_can_see_all_created_auctions
    visit(admin_auctions_path)

    assert(page.has_table?('auctions-table'))
    assert(page.has_link?('id.test', href: admin_auction_path(@auction.id)))
    assert(page.has_link?('expired.test', href: admin_auction_path(@expired_auction.id)))
  end
end
