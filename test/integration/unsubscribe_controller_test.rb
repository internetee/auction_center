require 'test_helper'

class UnsubscribeControllerTest < ActionDispatch::IntegrationTest
  def setup
    @participant = users(:participant)
  end

  def unsubscribe_token_for(user_id)
    Rails.application.message_verifier(:unsubscribe).generate(user_id)
  end

  def assert_hidden_daily_summary_false
    assert_includes response.body, 'name="user[daily_summary]"'
  end

  def test_unsubscribe_renders_form
    @participant.update!(daily_summary: true)
    token = unsubscribe_token_for(@participant.id)

    get unsubscribe_unsubscribe_path(id: token)

    assert_response :ok
    assert_hidden_daily_summary_false
  end

  def test_update_redirects_and_sets_notice
    @participant.update!(daily_summary: true)
    patch unsubscribe_update_path(id: @participant.id), params: {
      user: { daily_summary: false }
    }

    assert_response :redirect
    assert_redirected_to root_url
    assert_equal 'Subscription Cancelled', flash[:notice]
    assert_not @participant.reload.daily_summary
  end

  def test_update_failure_rerenders_unsubscribe
    User.stub(:find, @participant) do
      @participant.stub(:update, false) do
        patch unsubscribe_update_path(id: @participant.id), params: {
          user: { daily_summary: false }
        }
      end
    end

    assert_response :ok
    assert_hidden_daily_summary_false
  end
end
