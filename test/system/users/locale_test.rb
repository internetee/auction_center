require 'application_system_test_case'

class LocaleTest < ApplicationSystemTestCase
  def test_registered_user_can_change_their_locale
    @user = users(:participant)

    stub_request(:any, /eis_billing_system/)
      .to_return(status: 200, body: "{\"reference_number\":\"12332\"}", headers: {})

    sign_in(@user)

    visit root_path
    click_link('Eesti keeles')
    assert_text('Oksjonil olevad domeenid')
    @user.reload

    assert_equal('et', @user.locale)
  end
end
