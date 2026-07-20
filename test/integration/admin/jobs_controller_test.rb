require 'test_helper'

class AdminJobsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = users(:administrator)
    @participant = users(:participant)
  end

  def test_index_renders_for_admin
    sign_in @admin

    get admin_jobs_path

    assert_response :ok
    assert_includes response.body, 'ResultCreationJob'
  end

  def test_create_redirects_with_notice_for_valid_job
    sign_in @admin

    ResultCreationJob.stub(:perform_later, true) do
      post admin_jobs_path, params: { job: { job_class: 'ResultCreationJob' } }
    end

    assert_redirected_to admin_jobs_path
  end

  def test_create_redirects_with_error_when_job_fails
    sign_in @admin

    ResultCreationJob.stub(:perform_later, false) do
      post admin_jobs_path, params: { job: { job_class: 'ResultCreationJob' } }
    end

    assert_redirected_to admin_jobs_path
  end

  def test_create_returns_internal_server_error_for_valid_job_json_request
    sign_in @admin

    ResultCreationJob.stub(:perform_later, true) do
      post admin_jobs_path, params: { job: { job_class: 'ResultCreationJob' } }, as: :json
    end

    assert_response :internal_server_error
  end

  def test_create_redirects_with_alert_for_tampering
    sign_in @admin

    post admin_jobs_path, params: { job: { job_class: 'InvalidJobName' } }

    assert_redirected_to root_url
    assert_not_nil flash[:alert]
  end

  def test_index_returns_not_found_for_non_admin
    sign_in @participant

    get admin_jobs_path

    assert_response :not_found
  end
end
