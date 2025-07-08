require "test_helper"

class Pages::Offers::BlindAuctionOfferTable::ComponentTest < ViewComponent::TestCase
  def setup
    @offer = offers(:high_offer)
  end

  test "table does not include total with vat column" do
    component = Pages::Offers::BlindAuctionOfferTable::Component.new(offer: @offer)
    render_inline(component)
    
    # Check that "Total with VAT" column is not present in the rendered HTML
    assert_no_match /Total with VAT/i, rendered_content
    assert_no_match /#{I18n.t('offers.total')}/i, rendered_content
  end

  test "table includes all required columns" do
    component = Pages::Offers::BlindAuctionOfferTable::Component.new(offer: @offer)
    render_inline(component)
    
    # Check that all required columns are present in the rendered HTML
    assert_match /#{I18n.t('auctions.domain_name')}/, rendered_content
    assert_match /#{I18n.t('auctions.ends_at')}/, rendered_content
    assert_match /#{I18n.t('offers.price')}/, rendered_content
  end

  test "component renders successfully" do
    component = Pages::Offers::BlindAuctionOfferTable::Component.new(offer: @offer)
    render_inline(component)
    
    # Check that table and thead are present in the rendered HTML
    assert_match /<table/, rendered_content
    assert_match /<thead/, rendered_content
  end
end 