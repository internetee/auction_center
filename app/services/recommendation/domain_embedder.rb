module Recommendation
  # Wraps OpenAI text-embedding-3-small for batched embedding generation.
  # Input: array of DomainClassification rows (or {domain_name:, description:,
  # keywords:} hashes). Output: array of {domain_name:, embedding:} pairs.
  #
  # NOT called from runtime paths — only from EmbedUnembeddedDomainsJob (cron).
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

      response.fetch('data').sort_by { |item| item['index'] }.map { |item| item.fetch('embedding') }
    end

    def build_input(row)
      [
        domain_name_for(row),
        description_for(row),
        keywords_for(row).join(', ')
      ].reject(&:blank?).join('. ')
    end

    def domain_name_for(row)
      row.respond_to?(:domain_name) ? row.domain_name : row[:domain_name]
    end

    def description_for(row)
      row.respond_to?(:description) ? row.description : row[:description]
    end

    def keywords_for(row)
      raw = row.respond_to?(:keywords) ? row.keywords : row[:keywords]
      Array(raw)
    end
  end
end
