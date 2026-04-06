require 'test_helper'

class AdminResultsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActiveJob::TestHelper

  def setup
    @admin = users(:administrator)
    @participant = users(:participant)
    @result = results(:expired_participant)
  end

  def test_index_renders_for_admin
    sign_in @admin

    get admin_results_path

    assert_response :ok
    assert_includes response.body, @result.auction.domain_name
  end

  def test_show_renders_for_admin
    sign_in @admin

    get admin_result_path(@result.id)

    assert_response :ok
    assert_includes response.body, @result.auction.domain_name
  end

  def test_create_enqueues_job_and_redirects_for_admin
    sign_in @admin

    clear_enqueued_jobs
    assert_enqueued_with(job: ResultCreationJob) do
      post admin_results_path
    end

    assert_redirected_to admin_results_path
  end

  def test_create_returns_internal_server_error_when_job_fails
    sign_in @admin

    ResultCreationJob.stub(:perform_later, false) do
      post admin_results_path
    end

    assert_response :internal_server_error
  end

  def test_index_returns_not_found_for_non_admin
    sign_in @participant

    get admin_results_path

    assert_response :not_found
  end
end
