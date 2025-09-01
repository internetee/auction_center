require 'test_helper'

class AuctionsWishlistPriorityTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    super
    
    @participant = users(:participant)
    @auction_with_offers = auctions(:valid_with_offers)
    @auction_without_offers = auctions(:valid_without_offers)
    @english_auction = auctions(:english)
    
    WishlistItem.where(user: @participant).destroy_all
    
    travel_to Time.parse('2010-07-05 10:40 +0000').in_time_zone
  end

  def teardown
    super
    travel_back
    WishlistItem.where(user: @participant).destroy_all
  end

  def test_wishlist_auctions_have_priority_over_regular_auctions
    sign_in @participant
    
    WishlistItem.create!(user: @participant, domain_name: @auction_without_offers.domain_name)
    
    get auctions_path
    
    assert_response :success
    
    auction_domains = css_select('tbody#bids tr.contents td:first-child').map { |e| e.text.strip }
    
    with_offers_index = auction_domains.index(@auction_with_offers.domain_name)
    wishlist_without_offers_index = auction_domains.index(@auction_without_offers.domain_name)
    regular_english_index = auction_domains.index(@english_auction.domain_name)
    
    assert_not_nil with_offers_index, "Auction with offers should be present"
    assert_not_nil wishlist_without_offers_index, "Wishlist auction should be present"
    assert_not_nil regular_english_index, "Regular auction should be present"
    
    assert with_offers_index < wishlist_without_offers_index, 
           "Auction with offer should come before wishlist auction"
    assert wishlist_without_offers_index < regular_english_index, 
           "Wishlist auction should come before regular auction"
  end
end