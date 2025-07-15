require "test_helper"

class OffersIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @user = users(:administrator) 
    sign_in @user
  end

  test "offers index page loads successfully" do
    get offers_path
    assert_response :success
    assert_select "table" 
    assert_select "h1", text: I18n.t(:my_offers)
  end

  test "offers table has correct structure" do
    get offers_path
    assert_response :success
    
    assert_select "table"
    
    assert_select "table th", text: I18n.t('auctions.domain_name')
    assert_select "table th", text: I18n.t('auctions.type')
    assert_select "table th", text: I18n.t('offers.show.your_last_offer')
    assert_select "table th", text: I18n.t('auctions.ends_at')
    assert_select "table th", text: I18n.t('result_name')
    assert_select "table th", text: I18n.t('auctions.offer_actions')
    
    assert_select "table th", text: I18n.t('offers.total'), count: 0
  end

  test "offers page works without offers" do
    Offer.delete_all
    
    get offers_path
    assert_response :success
    assert_select "table" 
    assert_select "thead" 
    assert_select "h1", text: I18n.t(:my_offers) 
    
    assert_select "table th", text: I18n.t('auctions.domain_name')
    assert_select "table th", text: I18n.t('auctions.type')
    assert_select "table th", text: I18n.t('offers.show.your_last_offer')
    assert_select "table th", text: I18n.t('auctions.ends_at')
    assert_select "table th", text: I18n.t('result_name')
    assert_select "table th", text: I18n.t('auctions.offer_actions')
    
    assert_select "table th", text: I18n.t('offers.total'), count: 0
  end
end 