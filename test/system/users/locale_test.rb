require 'application_system_test_case'

class LocaleTest < ApplicationSystemTestCase
  def setup
    super

    stub_request(:post, "https://eis_billing_system:3000/api/v1/invoice_generator/reference_number_generator")
      .to_return(status: 200, body: "{\"reference_number\":\"12332\"}", headers: {})
  end

  def teardown
    super
  end

  def test_registered_user_can_change_their_locale
    @user = users(:participant)
    sign_in(@user)

    visit root_path
    click_link('Eesti keeles')
    assert_text('Oksjonil olevad domeenid')
    @user.reload

    assert_equal('et', @user.locale)
  end
end
