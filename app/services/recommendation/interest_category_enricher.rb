module Recommendation
  # v3 unified embedding space — the category-side mirror of LlmDomainClassifier
  # + DomainEmbedder. Turns an interest category ("Finance and fintech" /
  # "Finants ja fintech") into the same kind of rich, embeddable object a domain
  # is, so a selected category can act as a magnet in the same 1536-dim space.
  #
  # One pass, two OpenAI calls (chat for description+keywords, embeddings for the
  # vector) because the whole catalog is ~15 rows — no need for the two-job
  # split domains use. NOT a runtime path: only EnrichInterestCategoryJob and
  # PipelineRunner call this.
  #
  # Returns array of attribute hashes keyed by category code, ready to update
  # onto the matching InterestCategory:
  #   { code:, description:, keywords:, embedding:, embedding_model:, embedded_at: }
  class InterestCategoryEnricher
    DEFAULT_TEMPERATURE = 0.2
    BATCH_LIMIT = 50
    EMBED_MODEL = Recommendation::DomainEmbedder::MODEL

    class << self
      def call(...)
        new(...).call
      end
    end

    def initialize(categories:, temperature: DEFAULT_TEMPERATURE)
      @categories = Array(categories).reject { |c| c.code.to_s.blank? }.first(BATCH_LIMIT)
      @temperature = temperature
    end

    def call
      return [] if @categories.empty?

      enrichment = fetch_enrichment            # code => { description:, keywords: }
      embed_inputs = @categories.map { |category| build_embed_input(category, enrichment[category.code]) }
      vectors = fetch_embeddings(embed_inputs)

      @categories.each_with_index.map do |category, index|
        data = enrichment[category.code] || {}
        {
          code: category.code,
          description: data[:description],
          keywords: data[:keywords] || [],
          embedding: vectors[index],
          embedding_model: EMBED_MODEL,
          embedded_at: Time.current
        }
      end
    rescue StandardError, OpenAI::Error => e
      Rails.logger.warn("InterestCategoryEnricher failed: #{e.message}")
      raise
    end

    private

    # ---------- Enrichment (chat, structured output) --------------------

    def fetch_enrichment
      content = fetch_ai_response
      parsed = JSON.parse(content)
      parsed.fetch('categories', []).each_with_object({}) do |entry, acc|
        code = entry['code'].to_s.strip.downcase
        next if code.blank?

        acc[code] = {
          description: entry['description'].to_s.strip.presence,
          keywords: Array(entry['keywords']).map { |k| k.to_s.strip.downcase }.reject(&:blank?).uniq
        }
      end
    end

    def fetch_ai_response
      client = OpenAI::Client.new
      response = client.chat(parameters: chat_parameters)

      finish_reason = response.dig('choices', 0, 'finish_reason')
      raise StandardError, 'Incomplete response' if finish_reason == 'length'

      refusal = response.dig('choices', 0, 'message', 'refusal')
      raise StandardError, refusal if refusal

      content = response.dig('choices', 0, 'message', 'content')
      raise StandardError, response.dig('error', 'message') || 'No response content' if content.nil?

      content
    end

    def chat_parameters
      model_name = openai_model
      {
        model: model_name,
        response_format: { type: 'json_schema', json_schema: schema },
        messages: messages
      }.merge(OpenaiStructuredOutputSupport.temperature_options(model_name, @temperature))
    end

    def schema
      {
        name: 'interest_categories',
        schema: {
          type: 'object',
          properties: {
            categories: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  code:        { type: 'string' },
                  description: { type: 'string' },
                  keywords:    { type: 'array', items: { type: 'string' } }
                },
                required: %w[code description keywords],
                additionalProperties: false
              }
            }
          },
          required: ['categories'],
          additionalProperties: false
        },
        strict: true
      }
    end

    def messages
      payload = @categories.map { |c| { code: c.code, name_en: c.name_en, name_et: c.name_et } }
      [
        { role: 'system', content: system_message },
        { role: 'user',   content: { categories: payload }.to_json }
      ]
    end

    def system_message
      override = Setting.find_by(code: 'openai_interest_category_prompt')&.retrieve
      return override if override.present?

      <<~PROMPT.squish
        You enrich interest categories for a .ee domain recommendation system.
        For each category return one row keyed by its exact provided `code`.

        Rules:
        - description: one or two sentences describing the kind of businesses,
          products, or domains that belong to this category.
        - keywords: 10 to 20 lowercase semantic tokens that domains in this
          category would use. Include BOTH English and Estonian terms
          (the system serves an Estonian registry), e.g. for real estate:
          'real estate','property','rent','mortgage','kinnisvara','üür','laen'.
          No stopwords, no duplicates.
        - Keep it concrete and domain-oriented; these keywords are embedded and
          matched against real domain names by semantic similarity.
      PROMPT
    end

    def openai_model
      OpenaiStructuredOutputSupport.model(Setting.find_by(code: 'openai_model')&.retrieve)
    end

    # ---------- Embedding (embeddings endpoint) -------------------------

    def build_embed_input(category, data)
      keywords = Array(data && data[:keywords])
      [
        category.name_en,
        category.name_et,
        keywords.join(', ').presence
      ].compact.join('. ')
    end

    def fetch_embeddings(inputs)
      Recommendation::TextEmbedder.embed(inputs)
    end
  end
end
