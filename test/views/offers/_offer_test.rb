require "test_helper"

class Offers::OfferPartialTest < ActionView::TestCase
  def setup
    @offer = offers(:high_offer)
  end

  test "offer partial does not include total column" do
    render partial: 'offers/offer', locals: { offer: @offer }
    
    # Check that "Total with VAT" column is not present in the rendered HTML
    assert_select "td", text: /#{@offer.total}/, count: 0
  end

  test "offer partial includes required columns" do
    render partial: 'offers/offer', locals: { offer: @offer }
    
    # Check that required elements are present
    assert_select "td", text: @offer.auction.domain_name
    assert_select "td", text: /#{@offer.price}/
  end

  test "offer partial renders successfully" do
    render partial: 'offers/offer', locals: { offer: @offer }
    
    # Check that the partial renders without errors
    assert_select "tr"
    assert_select "td"
  end
end 