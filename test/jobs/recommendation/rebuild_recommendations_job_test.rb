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

    def test_first_slice_forces_and_chains_until_pipeline_is_complete
      calls = []
      results = [{ incomplete: true }, {}]
      original = Recommendation::PipelineRunner.method(:run)
      Recommendation::PipelineRunner.define_singleton_method(:run) do |force:, deadline:|
        calls << [force, deadline.future?]
        results.shift
      end

      assert_enqueued_with(job: Recommendation::RebuildRecommendationsJob, args: [1]) do
        Recommendation::RebuildRecommendationsJob.new.perform
      end
      assert_no_enqueued_jobs(only: Recommendation::RebuildRecommendationsJob) do
        Recommendation::RebuildRecommendationsJob.new.perform(1)
      end

      assert_equal [[true, true], [false, true]], calls
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
