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
    assert_text('ResultCreationJob')
    assert_text('InvoiceCreationJob')
    assert_text('InvoiceCancellationJob')
    assert_text('DailySummaryJob')

    assert(page.has_button?('Run', count: 4))

    within('tr.ResultCreationJob') do
      assert_enqueued_with(job: ResultCreationJob) do
        click_link_or_button('Run')
      end
    end

    assert_text('Job enqueued.')
  end

  def test_tampering_redirects_and_raises_an_error
    visit(admin_jobs_path)

    within('tr.ResultCreationJob') do
      page.evaluate_script("document.getElementById('job_job_class').value = 'FOO'")
      click_link_or_button('Run')
    end

    assert(page.has_css?(
             'div.alert',
             text: 'Tampering detected. You are signed out and the incident is reported.'
           ))
  end
end
