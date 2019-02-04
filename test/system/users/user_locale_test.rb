require 'application_system_test_case'

class UserLocaleTest < ApplicationSystemTestCase
  def setup
    super
  end

  def teardown
    super
  end

  def test_anonymous_user_can_change_locale
    visit root_path

    assert(page.has_link?('Eesti'))
  end

  def test_logged_in_user_can_change_locale
    visit root_path

    assert(page.has_link?)
  end
end
