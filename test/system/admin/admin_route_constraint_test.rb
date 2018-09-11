require 'application_system_test_case'

class AdminRouteConstraintTest < ApplicationSystemTestCase
  def setup
    super
    Capybara.current_driver = :rack_test
  end

  def teardown
    super
    Capybara.current_driver = :headless_chrome
  end

  def test_cannot_see_the_routes_as_user
    user = users(:user)
    sign_in(user)

    assert_raise(ActionController::RoutingError) do
      visit admin_users_path
    end
  end

  def test_cannot_see_the_routes_when_not_signed_in
    assert_raise(ActionController::RoutingError) do
      visit admin_users_path
    end
  end

  def test_can_see_the_routes_as_administrator
    user = users(:administrator)
    sign_in(user)

    visit admin_users_path

    assert_text('Joe John User')
    assert_text('John Joe Administrator')
  end
end
