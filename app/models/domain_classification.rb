class DomainClassification < ApplicationRecord
  HEURISTIC_SOURCE = 'heuristic'.freeze
  OPENAI_SOURCE = 'openai'.freeze
  MANUAL_SOURCE = 'manual'.freeze
  IMPORTED_SOURCE = 'imported'.freeze

  SOURCES = [HEURISTIC_SOURCE, OPENAI_SOURCE, MANUAL_SOURCE, IMPORTED_SOURCE].freeze

  LOW_CONFIDENCE_THRESHOLD = 0.6
  LLM_REFRESH_INTERVAL = 6.months

  validates :domain_name, presence: true, uniqueness: { case_sensitive: false }
  validates :classification_source, inclusion: { in: SOURCES }, allow_nil: true
  validates :confidence,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 },
            allow_nil: true
  validates :brandability_score,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 },
            allow_nil: true

  before_validation :normalize_domain_name

  scope :unclassified, -> { where(classified_at: nil) }
  scope :by_source, ->(source) { where(classification_source: source) }
  scope :low_confidence, -> { where('confidence IS NULL OR confidence < ?', LOW_CONFIDENCE_THRESHOLD) }
  scope :needs_llm_enrichment, lambda {
    where(classification_source: [HEURISTIC_SOURCE, nil])
      .or(where(confidence: ...LOW_CONFIDENCE_THRESHOLD))
      .or(where('classification_source = ? AND classified_at < ?', OPENAI_SOURCE, LLM_REFRESH_INTERVAL.ago))
  }
  scope :classified, -> { where.not(classified_at: nil) }

  def heuristic? = classification_source == HEURISTIC_SOURCE
  def from_llm? = classification_source == OPENAI_SOURCE

  def stale?
    return true if classification_source != OPENAI_SOURCE
    return true if classified_at.nil?

    classified_at < LLM_REFRESH_INTERVAL.ago
  end

  private

  def normalize_domain_name
    self.domain_name = domain_name.to_s.strip.downcase if domain_name.present?
  end
end
