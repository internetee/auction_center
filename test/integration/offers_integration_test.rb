require "test_helper"

class OffersIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @user = users(:administrator) # Use existing administrator fixture
    sign_in @user
  end

  test "offers index page loads successfully" do
    # Use existing fixtures data
    get offers_path
    assert_response :success
    assert_select "table" # Check that table exists
    assert_select "h1", text: I18n.t(:my_offers) # Check page title
  end

  test "offers table has correct structure" do
    # Use existing fixtures data
    get offers_path
    assert_response :success
    
    # Check that table exists (even if empty)
    assert_select "table"
    
    # Check that table has correct columns (without "Total with VAT" column)
    assert_select "table th", text: I18n.t('auctions.domain_name')
    assert_select "table th", text: I18n.t('auctions.type')
    assert_select "table th", text: I18n.t('offers.show.your_last_offer')
    assert_select "table th", text: I18n.t('auctions.ends_at')
    assert_select "table th", text: I18n.t('result_name')
    assert_select "table th", text: I18n.t('auctions.offer_actions')
    
    # Check that "Total with VAT" column is not present
    assert_select "table th", text: I18n.t('offers.total'), count: 0
  end

  test "offers page works without offers" do
    # Delete all offers to test empty state
    Offer.delete_all
    
    get offers_path
    assert_response :success
    assert_select "table" # Table should still exist
    assert_select "thead" # Table header should exist
    assert_select "h1", text: I18n.t(:my_offers) # Page title should still be present
    
    # Check that table headers are present (even without data)
    assert_select "table th", text: I18n.t('auctions.domain_name')
    assert_select "table th", text: I18n.t('auctions.type')
    assert_select "table th", text: I18n.t('offers.show.your_last_offer')
    assert_select "table th", text: I18n.t('auctions.ends_at')
    assert_select "table th", text: I18n.t('result_name')
    assert_select "table th", text: I18n.t('auctions.offer_actions')
    
    # Check that "Total with VAT" column is not present
    assert_select "table th", text: I18n.t('offers.total'), count: 0
  end
end 