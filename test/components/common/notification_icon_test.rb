require "test_helper"

class NotificationIconTest < ViewComponent::TestCase
  def setup
    @notification = Notification.create(
      recipient: users(:participant),
      type: "AuctionWinnerNotification",
      params: {},
      read_at: nil
    )
  end

  def test_render_component
    render_inline(Common::Notifications::Icon::Component.new(notification: @notification, readed: false))

    assert_selector "span.o-trophy-icon"
    assert_selector "h5.c-notification__header__title" do
      assert_text(/^You won! ?/)
      assert_selector "span.o-new"
    end
  end

  def test_render_differnt_types
    @notification.update(type: "AuctionWinnerNotification") && @notification.reload
    render_inline(Common::Notifications::Icon::Component.new(notification: @notification, readed: false))

    assert_selector "span.o-trophy-icon"
    assert_selector "h5.c-notification__header__title" do
      assert_text(/^You won! ?/)
      assert_selector "span.o-new"
    end

    @notification.update(type: "AuctionLooserNotification") && @notification.reload
    render_inline(Common::Notifications::Icon::Component.new(notification: @notification, readed: false))
    assert_selector "span.o-hammer-icon"
    assert_selector "h5.c-notification__header__title" do
      assert_text(/^You Lose! ?/)
      assert_selector "span.o-new"
    end

    @notification.update(type: "OfferNotification") && @notification.reload
    render_inline(Common::Notifications::Icon::Component.new(notification: @notification, readed: false))
    assert_selector "span.o-hammer-icon"
    assert_selector "h5.c-notification__header__title" do
      assert_text(I18n.t('english_offers.index.new_bid'))
      assert_selector "span.o-new"
    end

    @notification.update(type: "AuctionWinnerNotification") && @notification.reload
    render_inline(Common::Notifications::Icon::Component.new(notification: @notification, readed: true))
    assert_selector "span.c-notification__header__icon.o-trophy-icon"
    assert_selector "h5.c-notification__header__title" do
      assert_text(/^You won! ?/)
      assert_selector "span.o-new"
    end

    @notification.update(type: "AuctionLooserNotification") && @notification.reload
    render_inline(Common::Notifications::Icon::Component.new(notification: @notification, readed: true))
    assert_selector "span.c-notification__header__icon.o-hammer-icon"
    assert_selector "h5.c-notification__header__title" do
      assert_text(/^You Lose! ?/)
      assert_selector "span.o-new"
    end

    @notification.update(type: "OfferNotification") && @notification.reload
    render_inline(Common::Notifications::Icon::Component.new(notification: @notification, readed: true))
    assert_selector "span.c-notification__header__icon.o-hammer-icon"
    assert_selector "h5.c-notification__header__title" do
      assert_text(I18n.t('english_offers.index.new_bid'))
      assert_selector "span.o-new"
    end
  end
end