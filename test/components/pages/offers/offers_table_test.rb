require "test_helper"

class Pages::Offers::OffersTable::ComponentTest < ViewComponent::TestCase
  def setup
    @offers = []
  end

  test "table does not include total with vat column" do
    component = Pages::Offers::OffersTable::Component.new(offers: @offers)
    render_inline(component)
    
    assert_no_match /Total with VAT/i, rendered_content
    assert_no_match /#{I18n.t('offers.total')}/i, rendered_content
  end

  test "table includes all required columns" do
    component = Pages::Offers::OffersTable::Component.new(offers: @offers)
    render_inline(component)
    
    assert_match /#{I18n.t('auctions.domain_name')}/, rendered_content
    assert_match /#{I18n.t('auctions.type')}/, rendered_content
    assert_match /#{I18n.t('offers.show.your_last_offer')}/, rendered_content
    assert_match /#{I18n.t('auctions.ends_at')}/, rendered_content
    assert_match /#{I18n.t('result_name')}/, rendered_content
    assert_match /#{I18n.t('auctions.offer_actions')}/, rendered_content
  end

  test "component renders successfully" do
    component = Pages::Offers::OffersTable::Component.new(offers: @offers)
    render_inline(component)
    
    assert_match /<table/, rendered_content
    assert_match /<thead/, rendered_content
  end
end 