module Recommendation
  # Admin-triggered full rebuild of the recommendation pipeline, exposed in
  # /admin/jobs. Run it after changing the interest catalog (adding, renaming,
  # or deleting categories) so every domain is re-classified under the new
  # vocabulary, re-embedded, re-scored globally, and re-scored per user.
  #
  # Force mode re-hits the LLM for every domain, so this is intentionally a
  # manual button, not a callback on InterestCategory.
  class RebuildRecommendationsJob < ApplicationJob
    def perform
      Recommendation::PipelineRunner.run(force: true)
    end

    def self.needs_to_run?
      Feature.open_ai_integration_enabled?
    end
  end
end
