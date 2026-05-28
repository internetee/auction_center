module Recommendation
  # Generates OpenAI text-embedding-3-small vectors for a batch of
  # DomainClassification rows. NOT called from runtime paths — only
  # from EmbedUnembeddedDomainsJob (cron).
  #
  # Input text per domain: "<domain_name>. <comma-separated keywords>".
  # Description was intentionally removed (see ADR-001 + commit
  # "Remove description from domain_classifications"), so embedding
  # context is keywords + domain_name only. That's a deliberately
  # sparser signal but covers our recommendation use case where we
  # mostly want "this domain looks like the kind the user already bid on".
  #
  # Returns array of { domain_name:, embedding: [..1536..], embedding_model:, embedded_at: }
  # ready for update_columns on the matching DomainClassification.
  class DomainEmbedder
    MODEL = 'text-embedding-3-small'.freeze
    DIMENSIONS = 1536
    BATCH_LIMIT = 100

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
          embedded_at: Time.current
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
      parts = [
        domain_name_for(row),
        Array(keywords_for(row)).join(', ').presence
      ].compact
      parts.join('. ')
    end

    def domain_name_for(row)
      row.respond_to?(:domain_name) ? row.domain_name : row[:domain_name]
    end

    def keywords_for(row)
      raw = row.respond_to?(:keywords) ? row.keywords : row[:keywords]
      Array(raw)
    end
  end
end
