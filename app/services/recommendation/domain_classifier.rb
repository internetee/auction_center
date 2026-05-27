module Recommendation
  # Runtime entry point for classifying a single domain.
  #
  # This orchestrator NEVER calls the LLM. It runs structural analysis
  # + heuristic classification synchronously and upserts the result into
  # domain_classifications. The LLM enrichment pass runs in
  # ClassifyUnclassifiedDomainsJob (cron-driven, batched).
  #
  # Returns the persisted DomainClassification (or nil if domain_name is blank).
  class DomainClassifier
    FRESH_WINDOW = 1.hour

    class << self
      def call(...)
        new(...).call
      end
    end

    def initialize(domain_name, force: false)
      @domain_name = domain_name.to_s.strip.downcase
      @force = force
    end

    def call
      return nil if @domain_name.blank?

      existing = DomainClassification.find_by(domain_name: @domain_name)
      return existing if existing && !@force && fresh?(existing)

      attributes = DomainHeuristicClassifier.call(@domain_name)
      upsert_attributes = attributes.merge(updated_at: Time.current)

      record = existing || DomainClassification.new(domain_name: @domain_name)
      preserve_llm_fields!(record, attributes) if existing&.from_llm?

      record.assign_attributes(upsert_attributes.except(:domain_name))
      record.save!
      record
    end

    private

    def fresh?(record)
      record.classified_at.present? && record.classified_at > FRESH_WINDOW.ago
    end

    # If a row was previously enriched by the LLM, do NOT clobber the
    # rich fields with a weaker heuristic pass. Heuristic only refreshes
    # structural and provenance metadata in that case.
    def preserve_llm_fields!(record, attributes)
      %i[
        description description_locale keywords audience languages
        suggested_use_cases primary_category tags brandability_score
        confidence classification_source classification_model classified_at
      ].each { |field| attributes.delete(field) if record.send(field).present? }
    end
  end
end
