require 'application_system_test_case'

class DailyEmailButtonTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:participant)

    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/reference_number_generator").
      to_return(status: 200, body: "{\"reference_number\":\"12332\"}", headers: {})
  end

  def test_button_not_marked_without_login
    visit auctions_path

    assert_not(page.has_css?('.green.check.icon'))
  end

  def test_button_marked_if_subscribed_login
    @user.update(daily_summary: true)
    sign_in(@user)
    visit auctions_path

    assert(page.has_css?('.green.check.icon'))
  end

  def test_button_not_marked_if_unsubscribed_login
    @user.update(daily_summary: false)
    sign_in(@user)
    visit auctions_path

    assert_not(page.has_css?('.green.check.icon'))
  end
end
