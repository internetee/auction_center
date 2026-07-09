module Recommendation
  # One-command orchestrator for the whole recommendation pipeline:
  #   classify -> embed -> global ai_score -> per-user scores.
  #
  # Used by:
  #   - rake recommendation:init       (prod, force: false — incremental)
  #   - rake recommendation:init_demo  (staging — mock data, then this)
  #   - RebuildRecommendationsJob      (admin /admin/jobs, force: true — re-tag
  #                                     every domain after the interest catalog
  #                                     changed)
  #
  # Every stage runs synchronously and drains the per-run batch caps, so when
  # run returns the pipeline is actually complete — not merely enqueued.
  class PipelineRunner
    AI_SCORE_PROMPT_SETTING = 'openai_domains_evaluation_prompt'.freeze
    # db/seeds.rb seeds this setting with the literal placeholder 'prompt'.
    # Running ai_score against it produces meaningless scores, so we skip.
    AI_SCORE_PLACEHOLDER_PROMPT = 'prompt'.freeze
    # Safety cap so a stubborn domain that keeps re-entering scope can never
    # loop forever (progress detection already stops normal backlogs sooner).
    MAX_BATCHES = 100

    def self.run(force: false)
      new(force:).run
    end

    def initialize(force:)
      @force = force
      @summary = {}
    end

    def run
      unless Feature.open_ai_integration_enabled?
        log('OpenAI integration disabled — nothing to do')
        return @summary
      end

      if @force
        invalidate_classifications
        invalidate_category_embeddings
      end
      enrich_categories
      drain(Recommendation::ClassifyUnclassifiedDomainsJob, :classify) { classify_pending_count }
      drain(Recommendation::EmbedUnembeddedDomainsJob, :embed) { embed_pending_count }
      refresh_ai_scores
      refresh_user_scores

      log("pipeline complete: #{@summary.inspect}")
      @summary
    end

    private

    # force mode: push every LLM classification past the staleness threshold so
    # ClassifyUnclassifiedDomainsJob re-classifies it under the current interest
    # catalog. The re-classify upsert resets the embedding automatically, so the
    # embed stage repopulates vectors from the fresh keywords.
    def invalidate_classifications
      count = DomainClassification
              .where(classification_source: DomainClassification::OPENAI_SOURCE)
              .update_all(classified_at: 7.months.ago)
      @summary[:invalidated] = count
      log("force: invalidated #{count} classification(s) for re-run")
    end

    # Run the batched job until its pending backlog stops shrinking. Stopping on
    # "no progress" (rather than on needs_to_run?) means stubborn rows — e.g. a
    # domain the LLM keeps scoring below the confidence threshold — cost at most
    # one extra batch instead of looping.
    def drain(job_class, key)
      batches = 0
      previous = nil
      while (current = yield).positive? && (previous.nil? || current < previous) && batches < MAX_BATCHES
        job_class.perform_now
        previous = current
        batches += 1
      end
      @summary[key] = { batches:, remaining: yield }
      log("#{job_class.name}: #{batches} batch(es), #{@summary[key][:remaining]} remaining")
    end

    # v3: turn interest categories into embeddable magnets (LLM keywords + vector)
    # before scoring. Independent of domains — safe to run first. Cheap (~15 rows).
    def enrich_categories
      return unless InterestCategory.column_names.include?('embedding')

      count = Recommendation::EnrichInterestCategoriesJob.perform_now
      @summary[:categories_enriched] = count
      log("categories enriched: #{count.inspect}")
    end

    # force mode (catalog changed): drop category vectors so enrich_categories
    # rebuilds them under the new/edited vocabulary.
    def invalidate_category_embeddings
      return unless InterestCategory.column_names.include?('embedding')

      count = InterestCategory.update_all(embedded_at: nil, embedding: nil)
      @summary[:categories_invalidated] = count
      log("force: invalidated #{count} category embedding(s)")
    end

    def classify_pending_count
      Recommendation::ClassifyUnclassifiedDomainsJob.scope.count +
        Recommendation::ClassifyUnclassifiedDomainsJob.missing_domains.size
    end

    def embed_pending_count
      return 0 unless DomainClassification.column_names.include?('embedding')

      Recommendation::EmbedUnembeddedDomainsJob.scope.count
    end

    def refresh_ai_scores
      prompt = Setting.find_by(code: AI_SCORE_PROMPT_SETTING)&.retrieve.to_s.strip
      if prompt.blank? || prompt == AI_SCORE_PLACEHOLDER_PROMPT
        @summary[:ai_score] = :skipped
        log("skipping ai_score: #{AI_SCORE_PROMPT_SETTING} is not configured (#{prompt.inspect})")
        return
      end

      ActiveAuctionsAiSortingJob.perform_now
      @summary[:ai_score] = :done
      log('ai_score refreshed')
    end

    def refresh_user_scores
      count = 0
      User.where('? = ANY (roles)', User::PARTICIPANT_ROLE).find_each do |user|
        Recommendation::Scorer.refresh_for(user:)
        count += 1
      end
      @summary[:users_scored] = count
      log("personal scores refreshed for #{count} participant(s)")
    end

    def log(message)
      Rails.logger.info("[Recommendation::PipelineRunner] #{message}")
    end
  end
end
