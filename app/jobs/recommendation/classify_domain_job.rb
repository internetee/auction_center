module Recommendation
  # Classifies a single domain via the LLM as soon as it enters the system
  # (new auction / bid / wishlist add). Runs in the background, bounded to
  # at most one LLM call per not-yet-classified domain, so cost stays
  # predictable.
  #
  # The LLM maps any domain — Estonian, English, Finnish, transliterated
  # Russian, invented brand — onto the fixed InterestCatalog category codes.
  # No heuristic dictionary: the model figures out the category.
  #
  # The nightly ClassifyUnclassifiedDomainsJob is the safety net: it picks
  # up anything this job missed (e.g. OpenAI was disabled when the domain
  # first appeared, or the job failed) and re-classifies stale rows.
  class ClassifyDomainJob < ApplicationJob
    retry_on StandardError, wait: 10.seconds, attempts: 3

    def perform(domain_name)
      name = domain_name.to_s.strip.downcase
      return if name.blank?
      return unless Feature.open_ai_integration_enabled?
      return if already_classified?(name)

      attributes_list = Recommendation::LlmDomainClassifier.call(domain_names: [name])
      upsert(attributes_list)
    end

    private

    # Skip if we already have a non-stale LLM classification. A bare row
    # with no LLM data (or a stale one) is re-classified.
    def already_classified?(name)
      existing = DomainClassification.find_by(domain_name: name)
      existing&.from_llm? && !existing.stale?
    end

    def upsert(attributes_list)
      return 0 if attributes_list.blank?

      timestamps = { created_at: Time.current, updated_at: Time.current }
      rows = attributes_list.map { |attrs| attrs.merge(timestamps) }
      DomainClassification.upsert_all(rows, unique_by: :domain_name)
      rows.size
    end
  end
end
