require 'test_helper'

module Recommendation
  class PipelineRunnerTest < ActiveSupport::TestCase
    def test_no_op_when_openai_disabled
      with_feature_flag(false) do
        assert_equal({}, Recommendation::PipelineRunner.run)
      end
    end

    def test_force_invalidates_openai_classifications
      classification = DomainClassification.create!(
        domain_name: 'force-me.ee',
        classification_source: DomainClassification::OPENAI_SOURCE,
        confidence: 0.9,
        classified_at: 1.hour.ago
      )

      with_feature_flag(true) do
        with_no_pending do
          with_placeholder_prompt do
            stub_scorer do
              Recommendation::PipelineRunner.run(force: true)
            end
          end
        end
      end

      assert classification.reload.classified_at < 6.months.ago,
             'force must push openai classifications past the staleness threshold'
    end

    def test_skips_ai_score_when_prompt_is_placeholder
      with_feature_flag(true) do
        with_no_pending do
          with_placeholder_prompt do
            stub_scorer do
              refute_ai_sorting_called do
                summary = Recommendation::PipelineRunner.run
                assert_equal :skipped, summary[:ai_score]
              end
            end
          end
        end
      end
    end

    def test_scores_every_participant
      with_feature_flag(true) do
        with_no_pending do
          with_placeholder_prompt do
            stub_scorer do
              Recommendation::PipelineRunner.run
            end
          end
        end
      end

      expected = User.where('? = ANY (roles)', User::PARTICIPANT_ROLE).pluck(:id).sort
      assert_equal expected, @scored.sort
    end

    private

    def with_feature_flag(enabled)
      original = Feature.method(:open_ai_integration_enabled?)
      Feature.define_singleton_method(:open_ai_integration_enabled?) { enabled }
      yield
    ensure
      Feature.define_singleton_method(:open_ai_integration_enabled?, original)
    end

    # Make both batch stages see an empty backlog so they don't hit the LLM.
    def with_no_pending
      classify = Recommendation::ClassifyUnclassifiedDomainsJob
      embed = Recommendation::EmbedUnembeddedDomainsJob
      originals = {
        scope: classify.method(:scope),
        missing: classify.method(:missing_domains),
        embed_scope: embed.method(:scope)
      }
      classify.define_singleton_method(:scope) { DomainClassification.none }
      classify.define_singleton_method(:missing_domains) { [] }
      embed.define_singleton_method(:scope) { DomainClassification.none }
      yield
    ensure
      classify.define_singleton_method(:scope, originals[:scope])
      classify.define_singleton_method(:missing_domains, originals[:missing])
      embed.define_singleton_method(:scope, originals[:embed_scope])
    end

    def with_placeholder_prompt
      setting = Setting.find_by(code: 'openai_domains_evaluation_prompt')
      original = setting.value
      setting.update!(value: Recommendation::PipelineRunner::AI_SCORE_PLACEHOLDER_PROMPT)
      yield
    ensure
      setting.update!(value: original)
    end

    def stub_scorer
      original = Recommendation::Scorer.method(:refresh_for)
      @scored = []
      collected = @scored
      Recommendation::Scorer.define_singleton_method(:refresh_for) do |user:, **|
        collected << user.id
      end
      yield
    ensure
      Recommendation::Scorer.define_singleton_method(:refresh_for, original)
    end

    def refute_ai_sorting_called
      called = false
      original = ActiveAuctionsAiSortingJob.method(:perform_now)
      ActiveAuctionsAiSortingJob.define_singleton_method(:perform_now) { |*| called = true }
      yield
      refute called, 'ai_score job must not run when the prompt is the placeholder'
    ensure
      ActiveAuctionsAiSortingJob.define_singleton_method(:perform_now, original)
    end
  end
end
