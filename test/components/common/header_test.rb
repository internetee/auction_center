require 'test_helper'

class Common::Header::ComponentTest < ViewComponent::TestCase
  def setup
    Common::Header::Notification::Component.define_method(:user_signed_in?) { false }
  end

  def teardown
    Common::Header::Notification::Component.remove_method(:user_signed_in?)
  end

  def test_guest_sees_only_auctions_in_submenu
    render_header(user: nil)

    assert_selector '.submenu a', text: I18n.t(:auctions_name)
    assert_no_selector '.submenu a', text: I18n.t(:profile)
    assert_no_selector '.submenu a', text: I18n.t(:my_invoices)
    assert_no_selector '.submenu a', text: I18n.t(:my_offers)
    assert_no_selector '.submenu a', text: I18n.t(:my_wishlist)
  end

  def test_signed_in_participant_sees_account_links_in_submenu
    render_header(user: users(:participant))

    assert_selector '.submenu a', text: I18n.t(:auctions_name)
    assert_selector '.submenu a', text: I18n.t(:profile)
    assert_selector '.submenu a', text: I18n.t(:my_invoices)
    assert_selector '.submenu a', text: I18n.t(:my_offers)
    assert_selector '.submenu a', text: I18n.t(:my_wishlist)
  end

  private

  def render_header(user:)
    component = Common::Header::Component.new(notifications: nil)
    component.define_singleton_method(:user_signed_in?) { user.present? }
    component.define_singleton_method(:current_user) { user }

    with_request_url '/' do
      render_inline(component)
    end
  end
end
