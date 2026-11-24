module Recommendation
  # Admin-triggered full rebuild of the recommendation pipeline, exposed in
  # /admin/jobs. Run it after changing the interest catalog (adding, renaming,
  # or deleting categories) so every domain is re-classified under the new
  # vocabulary, re-embedded, re-scored globally, and re-scored per user.
  #
  # Force mode re-hits the LLM for every domain, so this is intentionally a
  # manual button, not a callback on InterestCategory.
  #
  # delayed_job kills any job after 5 minutes (config/initializers/delayed_job.rb),
  # while a full rebuild takes 10+ minutes, so it runs as a chain of time-boxed
  # slices: slice 0 only invalidates, every later slice continues where the
  # previous one stopped and re-enqueues the next until the pipeline is done.
  class RebuildRecommendationsJob < ApplicationJob
    # Checked between LLM calls, and one gpt-5 batch of 50 domains took up to ~2 min on dev,
    # so a slice ends at roughly budget + one batch, well under the 5-minute cap.
    TIME_BUDGET = 1.minute
    # shortcut: stops a chain whose LLM calls keep timing out; ~10k domains at 50 per slice fit.
    MAX_SLICES = 200

    def perform(slice = 0)
      summary = Recommendation::PipelineRunner.run(force: slice.zero?, deadline: TIME_BUDGET.from_now)
      return unless summary[:incomplete]

      if slice + 1 >= MAX_SLICES
        Rails.logger.error("[RebuildRecommendationsJob] gave up after #{MAX_SLICES} slices: #{summary.inspect}")
      else
        self.class.perform_later(slice + 1)
      end
    end

    def self.needs_to_run?
      Feature.open_ai_integration_enabled?
    end
  end
end
