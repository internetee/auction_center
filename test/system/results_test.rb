# encoding: UTF-8
require 'application_system_test_case'

class ResultsTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:participant)
    @result = results(:expired_participant)
    sign_in(@user)
  end

  def teardown
    super
  end

  def test_link_to_results_is_visible_from_offers_page
    visit(offers_path)

    assert(page.has_text?("You won"))
    assert(page.has_link?('Claim your domain'), href: result_path(@result))
  end

  def test_result_page_contains_result_info
    visit(result_path(@result))
    assert(page.has_text?("You won"))
    assert(page.has_text?("10.00 €"))
  end
end
