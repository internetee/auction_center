require 'test_helper'

class ActiveAuctionsAiSortingJobTest < ActiveJob::TestCase
  def setup
    super
    @auction1 = auctions(:valid_with_offers)
    @auction2 = auctions(:valid_without_offers)
    @auction3 = auctions(:english)
    travel_to Time.parse('2010-07-05 11:30 +0000').in_time_zone
  end

  def test_perform_with_enabled_openai_integration
    stub_request(:post, 'https://api.openai.com/v1/chat/completions')
      .to_return_json(status: 200, body: ai_response, headers: {})

    Feature.stub(:open_ai_integration_enabled?, true) do
      assert_ai_score_changes
    end
  end

  def test_perform_with_disabled_openai_integration
    Feature.stub(:open_ai_integration_enabled?, false) do
      assert_no_changes -> { @auction1.reload.ai_score } do
        assert_no_changes -> { @auction2.reload.ai_score } do
          assert_no_changes -> { @auction3.reload.ai_score } do
            ActiveAuctionsAiSortingJob.perform_now
          end
        end
      end
    end
  end

  private

  def assert_ai_score_changes
    assert_changes -> { @auction1.reload.ai_score }, from: 0, to: 9 do
      assert_changes -> { @auction2.reload.ai_score }, from: 0, to: 7 do
        assert_changes -> { @auction3.reload.ai_score }, from: 0, to: 4 do
          ActiveAuctionsAiSortingJob.perform_now
        end
      end
    end
  end

  def ai_response
    {
      'choices' => [{
        'message' => {
          'content': { scores:[
            { id: @auction1.id, domain_name: @auction1.domain_name, ai_score: 9 },
            { id: @auction2.id, domain_name: @auction2.domain_name, ai_score: 7 },
            { id: @auction3.id, domain_name: @auction3.domain_name, ai_score: 4 }
            ]}.to_json
        }
      }]
    }
  end
end
