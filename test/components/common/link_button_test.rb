require "test_helper"

class LinkButtonTest < ViewComponent::TestCase
  def setup
    @auction = auctions(:valid_with_offers)
  end

  def test_render_component
    render_inline(Common::Links::LinkButton::Component.new(
      link_title: 'Link', href: route.new_auction_english_offer_path(auction_uuid: @auction.uuid),
                    color: 'blue-secondary', options: { } )
    )

    assert_selector "a.c-btn.c-btn--blue-secondary[href='#{route.new_auction_english_offer_path(auction_uuid: @auction.uuid)}']", text: 'Link'
  end

  def test_render_nested_component
    render_inline(Common::Links::LinkButton::Component.new(
      link_title: 'Link', href: route.new_auction_english_offer_path(auction_uuid: @auction.uuid),
                    color: 'blue-secondary', options: { } )
    ) do
      'Edit'
    end

    assert_selector "a.c-btn.c-btn--blue-secondary.c-btn--icon[href='#{route.new_auction_english_offer_path(auction_uuid: @auction.uuid)}']", text: 'Edit'
  end


  def test_inline_button_colorize
    render_inline(Common::Links::LinkButton::Component.new(
      link_title: 'Link', href: route.new_auction_english_offer_path(auction_uuid: @auction.uuid),
                    color: 'blue-secondary', options: { } )
    )
    assert_selector "a.c-btn.c-btn--blue-secondary[href='#{route.new_auction_english_offer_path(auction_uuid: @auction.uuid)}']", text: 'Link'

    render_inline(Common::Links::LinkButton::Component.new(
      link_title: 'Link', href: route.new_auction_english_offer_path(auction_uuid: @auction.uuid),
                    color: 'green', options: { } )
    )
    assert_selector "a.c-btn.c-btn--green[href='#{route.new_auction_english_offer_path(auction_uuid: @auction.uuid)}']", text: 'Link'

    render_inline(Common::Links::LinkButton::Component.new(
      link_title: 'Link', href: route.new_auction_english_offer_path(auction_uuid: @auction.uuid),
                    color: 'blue', options: { } )
    )
    assert_selector "a.c-btn.c-btn--blue[href='#{route.new_auction_english_offer_path(auction_uuid: @auction.uuid)}']", text: 'Link'

    render_inline(Common::Links::LinkButton::Component.new(
      link_title: 'Link', href: route.new_auction_english_offer_path(auction_uuid: @auction.uuid),
                    color: 'orange', options: { } )
    )
    assert_selector "a.c-btn.c-btn--orange[href='#{route.new_auction_english_offer_path(auction_uuid: @auction.uuid)}']", text: 'Link'

    render_inline(Common::Links::LinkButton::Component.new(
      link_title: 'Link', href: route.new_auction_english_offer_path(auction_uuid: @auction.uuid),
                    color: 'black', options: { } )
    )
    assert_selector "a.c-btn.c-btn--black[href='#{route.new_auction_english_offer_path(auction_uuid: @auction.uuid)}']", text: 'Link'

    render_inline(Common::Links::LinkButton::Component.new(
      link_title: 'Link', href: route.new_auction_english_offer_path(auction_uuid: @auction.uuid),
                    color: 'ghost', options: { } )
    )
    assert_selector "a.c-btn.c-btn--ghost[href='#{route.new_auction_english_offer_path(auction_uuid: @auction.uuid)}']", text: 'Link'
  end

  def test_nested_button_colorize
    render_inline(Common::Links::LinkButton::Component.new(
      link_title: 'Link', href: route.new_auction_english_offer_path(auction_uuid: @auction.uuid),
                    color: 'blue-secondary', options: { } )
    ) do
      'Edit'
    end
    assert_selector "a.c-btn.c-btn--blue-secondary.c-btn--icon[href='#{route.new_auction_english_offer_path(auction_uuid: @auction.uuid)}']", text: 'Edit'

    render_inline(Common::Links::LinkButton::Component.new(
      link_title: 'Link', href: route.new_auction_english_offer_path(auction_uuid: @auction.uuid),
                    color: 'green', options: { } )
    ) do
      'Edit'
    end
    assert_selector "a.c-btn.c-btn--green.c-btn--icon[href='#{route.new_auction_english_offer_path(auction_uuid: @auction.uuid)}']", text: 'Edit'

    render_inline(Common::Links::LinkButton::Component.new(
      link_title: 'Link', href: route.new_auction_english_offer_path(auction_uuid: @auction.uuid),
                    color: 'blue', options: { } )
    ) do
      'Edit'
    end
    assert_selector "a.c-btn.c-btn--blue.c-btn--icon[href='#{route.new_auction_english_offer_path(auction_uuid: @auction.uuid)}']", text: 'Edit'

    render_inline(Common::Links::LinkButton::Component.new(
      link_title: 'Link', href: route.new_auction_english_offer_path(auction_uuid: @auction.uuid),
                    color: 'orange', options: { } )
    ) do
      'Edit'
    end
    assert_selector "a.c-btn.c-btn--orange.c-btn--icon[href='#{route.new_auction_english_offer_path(auction_uuid: @auction.uuid)}']", text: 'Edit'

    render_inline(Common::Links::LinkButton::Component.new(
      link_title: 'Link', href: route.new_auction_english_offer_path(auction_uuid: @auction.uuid),
                    color: 'black', options: { } )
    ) do
      'Edit'
    end
    assert_selector "a.c-btn.c-btn--black.c-btn--icon[href='#{route.new_auction_english_offer_path(auction_uuid: @auction.uuid)}']", text: 'Edit'

    render_inline(Common::Links::LinkButton::Component.new(
      link_title: 'Link', href: route.new_auction_english_offer_path(auction_uuid: @auction.uuid),
                    color: 'ghost', options: { } )
    ) do
      'Edit'
    end
    assert_selector "a.c-btn.c-btn--ghost.c-btn--icon[href='#{route.new_auction_english_offer_path(auction_uuid: @auction.uuid)}']", text: 'Edit'
  end
end
