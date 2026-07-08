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

      # Serialize concurrent jobs for the SAME domain. Two enqueue paths can
      # fire almost simultaneously (auction after_create + first bid), and
      # without this both pass already_classified? and each makes a paid LLM
      # call. A worker that can't grab the lock skips the domain — it's being
      # handled, and the nightly ClassifyUnclassifiedDomainsJob is the backstop.
      with_domain_lock(name) do |acquired|
        next unless acquired
        next if already_classified?(name) # re-check now that we hold the lock

        attributes_list = Recommendation::LlmDomainClassifier.call(domain_names: [name])
        upsert(attributes_list)
      end
    end

    private

    # Skip if we already have a non-stale LLM classification. A bare row
    # with no LLM data (or a stale one) is re-classified.
    def already_classified?(name)
      existing = DomainClassification.find_by(domain_name: name)
      existing&.from_llm? && !existing.stale?
    end

    # Postgres session-level advisory lock, keyed by the domain. pg_try_* is
    # non-blocking: it yields false immediately if another worker holds it, so
    # we never tie up a worker waiting. Always unlocked in the ensure.
    def with_domain_lock(name)
      key = advisory_key(name)
      conn = DomainClassification.connection
      acquired = conn.select_value("SELECT pg_try_advisory_lock(#{key})")
      yield acquired
    ensure
      conn.execute("SELECT pg_advisory_unlock(#{key})") if acquired
    end

    # Stable 60-bit positive integer (fits a signed bigint) derived from the
    # domain, namespaced so it can't collide with advisory locks elsewhere.
    def advisory_key(name)
      Digest::SHA256.hexdigest("classify_domain:#{name}")[0, 15].to_i(16)
    end

    def upsert(attributes_list)
      return 0 if attributes_list.blank?

      timestamps = { created_at: Time.current, updated_at: Time.current }
      reset = DomainClassification.embedding_reset_attributes
      rows = attributes_list.map { |attrs| attrs.merge(timestamps, reset) }
      DomainClassification.upsert_all(rows, unique_by: :domain_name)
      rows.size
    end
  end
end
