require 'test_helper'

class AuctionPresenterTest < ActiveSupport::TestCase
  def test_auction_offer_button_returns_english_button_for_english_auction
    auction = auctions(:english)
    presenter = AuctionPresenter.new(auction)

    html = presenter.auction_offer_button(users(:participant))
    assert_includes html, I18n.t('auctions.bid')
    assert_includes html, 'button'
  end

  def test_auction_offer_button_returns_blind_button_for_blind_auction
    auction = auctions(:valid_with_offers)
    presenter = AuctionPresenter.new(auction)

    html = presenter.auction_offer_button(users(:participant))
    assert_includes html, 'button'
  end

  def test_english_auction_button_returns_default_when_user_nil
    auction = auctions(:english)
    presenter = AuctionPresenter.new(auction)

    html = presenter.english_auction_button(nil)
    assert_includes html, I18n.t('auctions.bid')
    assert_includes html, 'bid_button'
  end
end
