module Recommendation
  # Triggered on every new auction / wishlist / offer event.
  # Runs heuristic-only classification — NEVER calls the LLM.
  # Idempotent: DomainClassifier returns the existing fresh row without work.
  class ClassifyDomainHeuristicallyJob < ApplicationJob
    retry_on StandardError, wait: 5.seconds, attempts: 3

    def perform(domain_name)
      return if domain_name.to_s.strip.blank?

      Recommendation::DomainClassifier.call(domain_name)
    end
  end
end
