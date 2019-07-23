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

    assert(page.has_text?('You won'))
    assert(page.has_link?('Claim your domain'), href: result_path(@result.uuid))
  end

  def test_result_page_contains_result_info
    visit(result_path(@result.uuid))
    assert(page.has_text?('You won'))
  end

  def test_results_page_contains_transfer_code_if_result_is_paid
    @result.payment_received!
    assert(@result.payment_received?)

    visit(result_path(@result.uuid))
    assert(page.has_text?('332c70cdd0791d185778e0cc2a4eddea'))
  end

  def test_visiting_results_path_triggers_invoice_creation_job
    assert_enqueued_with(job: InvoiceCreationJob) do
      visit(result_path(@result.uuid))

      assert_text('We are generating the invoice, please check back in a few minutes.')
    end
  end
end
