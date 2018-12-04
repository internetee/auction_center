# encoding: UTF-8
require 'application_system_test_case'

class ResultsTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

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
  end

  def test_visiting_results_path_triggers_invoice_creation_job
    assert_enqueued_with(job: InvoiceCreationJob) do
      visit(result_path(@result))

      assert_text('We are generating the invoice, please check back in a few minutes.')
    end
  end
end
