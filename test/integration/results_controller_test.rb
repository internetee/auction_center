require 'test_helper'

class ResultsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActiveJob::TestHelper

  def setup
    @user = users(:participant)
    @other_user = users(:second_place_participant)
    @result = results(:with_invoice)
  end

  def sign_in_user(user = @user)
    sign_in user
  end

  def get_result(uuid, invoice_job_needed: false)
    InvoiceCreationJob.stub(:needs_to_run?, invoice_job_needed) do
      get result_path(uuid)
    end
  end

  def test_show_runs_invoice_creation_job_when_needed
    sign_in_user
    clear_enqueued_jobs

    assert_enqueued_with(job: InvoiceCreationJob) do
      get_result(@result.uuid, invoice_job_needed: true)
    end

    assert_response :ok
  end

  def test_show_requires_authentication
    get_result(@result.uuid)

    assert_redirected_to new_user_session_path
  end

  def test_show_renders_for_result_owner
    sign_in_user

    get_result(@result.uuid)
    assert_response :ok
    assert_includes response.body, 'modals--offer-modal'
  end

  def test_show_returns_not_found_for_other_users_result
    sign_in_user(@other_user)

    get_result(@result.uuid)
    assert_response :not_found
  end
end
