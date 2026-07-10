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

  scope :needs_llm_enrichment, lambda {
    where(classification_source: [HEURISTIC_SOURCE, nil])
      .or(where(confidence: ...LOW_CONFIDENCE_THRESHOLD))
      .or(where('classification_source = ? AND classified_at < ?', OPENAI_SOURCE, LLM_REFRESH_INTERVAL.ago))
  }
  scope :classified, -> { where.not(classified_at: nil) }
  # A classified row needs (re-)embedding when it has no vector yet OR its vector
  # was built under an older DomainEmbedder input format. The explicit NULL branch
  # is required: `where.not(embedding_input_version: current)` excludes NULLs in
  # SQL (NULL != x is unknown), and every pre-versioning row has NULL here.
  scope :needs_embedding, lambda {
    next none unless column_names.include?('embedding')

    base = classified
    next base.where(embedding: nil) unless column_names.include?('embedding_input_version')

    current = Recommendation::DomainEmbedder::INPUT_VERSION
    base.where(embedding: nil)
        .or(base.where(embedding_input_version: nil))
        .or(base.where.not(embedding_input_version: current))
  }

  # Columns to null out whenever a row is (re)classified. The embedding is built
  # from the classification fields (see Recommendation::DomainEmbedder), so a
  # fresh classification makes the stored vector stale; nulling these lets
  # EmbedUnembeddedDomainsJob recompute it on its next run.
  def self.embedding_reset_attributes
    return {} unless column_names.include?('embedding')

    attrs = { embedding: nil, embedding_model: nil, embedded_at: nil }
    attrs[:embedding_input_version] = nil if column_names.include?('embedding_input_version')
    attrs
  end

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
