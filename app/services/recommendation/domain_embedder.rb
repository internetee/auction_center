module Recommendation
  # Generates OpenAI text-embedding-3-small vectors for a batch of
  # DomainClassification rows. NOT called from runtime paths — only
  # from EmbedUnembeddedDomainsJob (cron).
  #
  # Input text per domain is a rich, structured summary:
  #   "<domain_name>. <description>. Category: <primary_category>.
  #    Tags: <tags>. Use cases: <use_cases>. Audience: <audience>.
  #    Keywords: <keywords>"
  # (empty parts are dropped). The earlier format was only
  # "<domain_name>. <keywords>" — a deliberately sparse signal (ADR-001) that
  # under-served interest/wishlist matching; INPUT_VERSION tracks the format so
  # rows built under an older version can be re-embedded without re-classifying.
  #
  # Returns array of { domain_name:, embedding: [..1536..], embedding_model:,
  # embedded_at:, embedding_input_version: } ready for update_columns on the
  # matching DomainClassification.
  class DomainEmbedder
    MODEL = 'text-embedding-3-small'.freeze
    DIMENSIONS = 1536
    BATCH_LIMIT = 100
    # Bump whenever build_input's format changes so needs_embedding re-embeds
    # existing rows. v1 = "<domain_name>. <keywords>"; v2 = rich structured text.
    INPUT_VERSION = 2

    class << self
      def call(...)
        new(...).call
      end
    end

    def initialize(rows:)
      @rows = Array(rows).first(BATCH_LIMIT)
    end

    def call
      return [] if @rows.empty?

      inputs = @rows.map { |row| build_input(row) }
      vectors = fetch_embeddings(inputs)

      @rows.each_with_index.map do |row, index|
        {
          domain_name: domain_name_for(row),
          embedding: vectors[index],
          embedding_model: MODEL,
          embedded_at: Time.current,
          embedding_input_version: INPUT_VERSION
        }
      end
    rescue StandardError, OpenAI::Error => e
      Rails.logger.warn("DomainEmbedder failed: #{e.message}")
      raise
    end

    private

    def fetch_embeddings(inputs)
      client = OpenAI::Client.new
      response = client.embeddings(parameters: { model: MODEL, input: inputs })

      error = response.dig('error', 'message')
      raise StandardError, error if error

      data = response.fetch('data')
      data.sort_by { |item| item['index'] }.map { |item| item.fetch('embedding') }
    end

    def build_input(row)
      tags = Array(field(row, :tags)).map { |t| t.to_s.tr('_', ' ') }.reject(&:blank?)
      use_cases = Array(field(row, :suggested_use_cases)).map(&:to_s).reject(&:blank?)
      keywords = Array(keywords_for(row)).map(&:to_s).reject(&:blank?)

      parts = [
        domain_name_for(row),
        field(row, :description).to_s.strip.presence,
        labelled('Category', field(row, :primary_category)),
        labelled('Tags', tags.join(', ').presence),
        labelled('Use cases', use_cases.join(', ').presence),
        labelled('Audience', field(row, :audience)),
        labelled('Keywords', keywords.join(', ').presence)
      ].compact
      parts.join('. ')
    end

    # "Label: value" or nil when value is blank, so absent fields never leave
    # dangling "Category: ." fragments in the embedding input.
    def labelled(label, value)
      value = value.to_s.strip
      return nil if value.blank?

      "#{label}: #{value}"
    end

    def domain_name_for(row)
      field(row, :domain_name)
    end

    def keywords_for(row)
      Array(field(row, :keywords))
    end

    def field(row, name)
      row.respond_to?(name) ? row.public_send(name) : row[name]
    end
  end
end
