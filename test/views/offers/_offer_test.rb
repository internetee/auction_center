require "test_helper"

class Offers::OfferPartialTest < ActionView::TestCase
  def setup
    @offer = offers(:high_offer)
  end

  test "offer partial does not include total column" do
    render partial: 'offers/offer', locals: { offer: @offer }
    
    assert_no_match /Total with VAT/i, @rendered
    assert_no_match /#{I18n.t('offers.total')}/i, @rendered
  end

  test "offer partial includes required columns" do
    render partial: 'offers/offer', locals: { offer: @offer }
    
    assert_select "td", text: @offer.auction.domain_name
    assert_select "td", text: /#{@offer.price}/
  end

  test "offer partial renders successfully" do
    render partial: 'offers/offer', locals: { offer: @offer }
    
    assert_select "tr"
    assert_select "td"
  end
end 