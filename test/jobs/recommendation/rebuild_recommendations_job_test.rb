require 'test_helper'

module Recommendation
  class RebuildRecommendationsJobTest < ActiveJob::TestCase
    def test_needs_to_run_follows_feature_flag
      with_feature_flag(false) do
        refute Recommendation::RebuildRecommendationsJob.needs_to_run?
      end
      with_feature_flag(true) do
        assert Recommendation::RebuildRecommendationsJob.needs_to_run?
      end
    end

    def test_perform_runs_pipeline_with_force
      captured = nil
      original = Recommendation::PipelineRunner.method(:run)
      Recommendation::PipelineRunner.define_singleton_method(:run) do |force: false|
        captured = force
        {}
      end

      Recommendation::RebuildRecommendationsJob.new.perform

      assert_equal true, captured
    ensure
      Recommendation::PipelineRunner.define_singleton_method(:run, original)
    end

    private

    def with_feature_flag(enabled)
      original = Feature.method(:open_ai_integration_enabled?)
      Feature.define_singleton_method(:open_ai_integration_enabled?) { enabled }
      yield
    ensure
      Feature.define_singleton_method(:open_ai_integration_enabled?, original)
    end
  end
end
