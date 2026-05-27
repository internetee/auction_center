require 'test_helper'

class AuctionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    super
    
    @participant = users(:participant)
    @second_participant = users(:second_place_participant)
    
    @auction_with_offers = auctions(:valid_with_offers)
    
    @auction_without_offers = auctions(:valid_without_offers)
    @english_auction = auctions(:english)
    @orphaned_auction = auctions(:orphaned) 
    @deposit_auction = auctions(:deposit_english)
    
    travel_to Time.parse('2010-07-05 10:40 +0000').in_time_zone
  end

  def teardown
    super
    travel_back
  end

  def test_anonymous_user_sees_auctions_sorted_by_ai_score
    get auctions_path
    
    assert_response :success
    assert_select 'tbody#bids tr.contents', 5
  end

  def test_logged_in_user_sees_auctions_with_offers_first
    sign_in @participant
    
    get auctions_path
    
    assert_response :success
    
    auction_domains = css_select('tbody#bids tr.contents td:first-child').map { |e| e.text.strip }
    
    with_offers_index = auction_domains.index(@auction_with_offers.domain_name)
    without_offers_index = auction_domains.index(@auction_without_offers.domain_name)
    english_index = auction_domains.index(@english_auction.domain_name)
    
    assert_not_nil with_offers_index, "Auction with offers should be present"
    assert_not_nil without_offers_index, "Auction without offers should be present"
    assert_not_nil english_index, "English auction should be present"
    
    assert with_offers_index < without_offers_index, "Auction with user's offer should come before auction without"
    assert with_offers_index < english_index, "Auction with user's offer should come before english auction"
  end

  def test_different_users_see_their_own_auctions_first
    sign_in @participant
    get auctions_path
    
    auction_domains_participant = css_select('tbody#bids tr.contents td:first-child').map { |e| e.text.strip }
    
    with_offers_index = auction_domains_participant.index(@auction_with_offers.domain_name)
    without_offers_index = auction_domains_participant.index(@auction_without_offers.domain_name)
    
    assert_not_nil with_offers_index
    assert_not_nil without_offers_index
    assert with_offers_index < without_offers_index
    
    sign_out @participant
    
    sign_in @second_participant
    get auctions_path
    
    auction_domains_second = css_select('tbody#bids tr.contents td:first-child').map { |e| e.text.strip }
    
    with_offers_index = auction_domains_second.index(@auction_with_offers.domain_name)
    without_offers_index = auction_domains_second.index(@auction_without_offers.domain_name)
    
    assert_not_nil with_offers_index
    assert_not_nil without_offers_index
    assert with_offers_index < without_offers_index
  end

  def test_explicit_sorting_overrides_user_auction_priority
    sign_in @participant
    
    get auctions_path, params: { sort_by: 'domain_name', sort_direction: 'asc' }
    
    assert_response :success
    
    auction_domains = css_select('tbody#bids tr.contents td:first-child').map { |e| e.text.strip }
    
    sorted_domains = auction_domains.sort
    assert_equal sorted_domains, auction_domains
  end

  def test_recommendation_scores_are_used_before_global_ai_score_for_logged_in_users
    sign_in @participant

    UserAuctionScore.create!(
      user: @participant,
      auction: @english_auction,
      score: 0.95,
      calculated_at: Time.current
    )
    UserAuctionScore.create!(
      user: @participant,
      auction: @auction_without_offers,
      score: 0.10,
      calculated_at: Time.current
    )

    get auctions_path

    assert_response :success

    auction_domains = css_select('tbody#bids tr.contents td:first-child').map { |e| e.text.strip }

    with_offers_index = auction_domains.index(@auction_with_offers.domain_name)
    english_index = auction_domains.index(@english_auction.domain_name)
    without_offers_index = auction_domains.index(@auction_without_offers.domain_name)

    assert with_offers_index < english_index, "User's own auction should still come first"
    assert english_index < without_offers_index, "Higher recommendation score should outrank lower score"
  end

  def test_interest_categories_prioritize_matching_classified_auctions
    sign_in @participant
    @participant.create_recommendation_profile!(interest_keywords: ['saas'])

    @english_auction.update!(classification_tags: ['saas'], primary_category: 'saas')
    @auction_without_offers.update!(classification_tags: ['shop_brand'], primary_category: 'shop_brand')

    get auctions_path

    assert_response :success

    auction_domains = css_select('tbody#bids tr.contents td:first-child').map { |e| e.text.strip }

    with_offers_index = auction_domains.index(@auction_with_offers.domain_name)
    english_index = auction_domains.index(@english_auction.domain_name)
    without_offers_index = auction_domains.index(@auction_without_offers.domain_name)

    assert with_offers_index < english_index, "User's own auction should still come first"
    assert english_index < without_offers_index, "Classified category match should outrank non-matching auction"
  end

  def test_custom_other_interests_prioritize_domain_name_matches
    sign_in @participant
    @participant.create_recommendation_profile!(interest_keywords: ['other', 'custom:english'])

    get auctions_path

    assert_response :success

    auction_domains = css_select('tbody#bids tr.contents td:first-child').map { |e| e.text.strip }

    with_offers_index = auction_domains.index(@auction_with_offers.domain_name)
    english_index = auction_domains.index(@english_auction.domain_name)
    without_offers_index = auction_domains.index(@auction_without_offers.domain_name)

    assert with_offers_index < english_index, "User's own auction should still come first"
    assert english_index < without_offers_index, "Custom other interests should boost matching domain names"
  end

  def test_sorting_with_pagination_keeps_user_auctions_prioritized
    sign_in @participant
    
    get auctions_path, params: { page: 1 }
    
    assert_response :success
    
    page1_domains = css_select('tbody#bids tr.contents td:first-child').map { |e| e.text.strip }
    
    assert page1_domains.include?(@auction_with_offers.domain_name), "Auction with user's offer should be on first page"
  end

  def test_json_api_returns_auctions_with_user_priority
    sign_in @participant
    
    get auctions_path, headers: { 'Accept': 'application/json' }
    
    assert_response :success
    
    response_json = JSON.parse(response.body)
    auction_domains = response_json.map { |a| a['domain_name'] }
    
    with_offers_index = auction_domains.index(@auction_with_offers.domain_name)
    without_offers_index = auction_domains.index(@auction_without_offers.domain_name)
    
    assert_not_nil with_offers_index, "Auction with offers should be in response"
    assert_not_nil without_offers_index, "Auction without offers should be in response"
    assert with_offers_index < without_offers_index, "Auction with user's offer should come before auction without"
  end

  def test_admin_user_does_not_get_priority_sorting
    @admin = users(:administrator)
    sign_in @admin
    
    get auctions_path, params: { admin: 'true' }
    
    assert_response :success
  end
end