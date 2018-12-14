require 'application_system_test_case'

class AdminJobsTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  def setup
    super

    @adminstrator = users(:administrator)
    sign_in(@adminstrator)
  end

  def teardown
    super
  end

  def test_administrator_can_schedule_jobs_on_demand
    visit(admin_jobs_path)
    assert_text('Periodic jobs')
    assert_text("ResultCreationJob")
    assert_text("InvoiceCreationJob")
    assert_text("InvoiceCancellationJob")

    assert(page.has_button?('Run', count: 3))

    within("tr.ResultCreationJob") do
      assert_enqueued_with(job: ResultCreationJob) do
        click_link_or_button('Run')
      end
    end

    assert_text('Job enqueued.')
  end
end
