module Recommendation
  # Tier 2 classifier: OpenAI structured outputs.
  #
  # Accepts an array of domain names (strings), returns array of attribute
  # hashes ready to upsert into domain_classifications. NOT called from
  # runtime paths — only from ClassifyUnclassifiedDomainsJob (cron).
  #
  # Cost: ~$0.30/month at steady state (one batch of ~5-20 domains per
  # day). Backfill: ~$1 one-time over thousands of historical domains.
  class LlmDomainClassifier
    DEFAULT_TEMPERATURE = 0.2
    BATCH_LIMIT = 50

    AUDIENCE_VALUES = %w[b2b b2c mixed unclear].freeze
    DESCRIPTION_LOCALES = %w[en et].freeze

    class << self
      def call(...)
        new(...).call
      end
    end

    def initialize(domain_names:, temperature: DEFAULT_TEMPERATURE)
      @domain_names = Array(domain_names).map { |d| d.to_s.strip.downcase }.uniq.reject(&:blank?).first(BATCH_LIMIT)
      @temperature = temperature
    end

    def call
      return [] if @domain_names.empty?

      response_content = fetch_ai_response
      parsed = JSON.parse(response_content)
      raw_response = parsed
      parsed.fetch('classifications', []).filter_map do |entry|
        build_attributes(entry, raw_response)
      end
    rescue StandardError, OpenAI::Error => e
      Rails.logger.warn("LlmDomainClassifier failed: #{e.message}")
      raise
    end

    private

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
        name: 'domain_classifications',
        schema: {
          type: 'object',
          properties: {
            classifications: {
              type: 'array',
              items: classification_item_schema
            }
          },
          required: ['classifications'],
          additionalProperties: false
        },
        strict: true
      }
    end

    def classification_item_schema
      {
        type: 'object',
        properties: {
          domain_name:         { type: 'string' },
          primary_category:    { type: 'string', enum: Recommendation::InterestCatalog.categories },
          tags:                { type: 'array', items: { type: 'string', enum: Recommendation::InterestCatalog.categories } },
          description:         { type: 'string' },
          description_locale:  { type: 'string', enum: DESCRIPTION_LOCALES },
          keywords:            { type: 'array', items: { type: 'string' } },
          audience:            { type: 'string', enum: AUDIENCE_VALUES },
          languages:           { type: 'array', items: { type: 'string' } },
          suggested_use_cases: { type: 'array', items: { type: 'string' } },
          brandability_score:  { type: 'number' },
          confidence:          { type: 'number' }
        },
        required: %w[
          domain_name primary_category tags description description_locale
          keywords audience languages suggested_use_cases brandability_score confidence
        ],
        additionalProperties: false
      }
    end

    def messages
      [
        { role: 'system', content: system_message },
        { role: 'user',   content: { domains: @domain_names }.to_json }
      ]
    end

    def system_message
      override = Setting.find_by(code: 'openai_domain_classification_prompt')&.retrieve
      return override if override.present?

      <<~PROMPT.squish
        You enrich .ee auction domain names with structured marketing metadata
        for a recommendation system. For each provided domain return one row.

        Rules:
        - primary_category and tags MUST come from this fixed vocabulary:
          #{Recommendation::InterestCatalog.categories.join(', ')}.
        - tags: 1 to 4 entries; primary_category must be one of them.
        - description: 1-2 sentences, neutral, marketing-style, no fluff,
          no claims about ownership, no inventing facts. If domain meaning
          is unclear, say so plainly.
        - description_locale: 'et' if the domain is clearly Estonian
          (Estonian word/root), otherwise 'en'.
        - keywords: 2-6 lowercase semantic tokens extracted or inferred
          from the domain. No stopwords.
        - audience: 'b2b' for business buyers, 'b2c' for consumers,
          'mixed' if both, 'unclear' if not inferable.
        - languages: subset of ['et','en'] depending on which language(s)
          the domain reads as.
        - suggested_use_cases: 1-4 short lowercase nouns describing what
          someone could build (e.g. 'shop','blog','agency','marketplace',
          'directory','service').
        - brandability_score: float 0..1. 1.0 = memorable, short, no
          numbers/hyphens, evocative. 0.0 = literal/awkward/numeric.
        - confidence: float 0..1 measuring your overall certainty.
        Prefer 'unclear' / lower confidence over invented data.
      PROMPT
    end

    def openai_model
      OpenaiStructuredOutputSupport.model(Setting.find_by(code: 'openai_model')&.retrieve)
    end

    def build_attributes(entry, raw_response)
      domain_name = entry['domain_name'].to_s.strip.downcase
      return nil if domain_name.blank?

      tags = sanitize_categories(entry['tags'])
      primary = sanitize_category(entry['primary_category'])
      primary = tags.first if primary.blank? && tags.any?

      {
        domain_name: domain_name,
        primary_category: primary,
        tags: tags,
        description: entry['description'].to_s.strip.presence,
        description_locale: sanitize_locale(entry['description_locale']),
        keywords: Array(entry['keywords']).map { |k| k.to_s.strip.downcase }.reject(&:blank?).uniq,
        audience: AUDIENCE_VALUES.include?(entry['audience']) ? entry['audience'] : nil,
        languages: Array(entry['languages']).map { |l| l.to_s.strip.downcase }.reject(&:blank?).uniq,
        suggested_use_cases: Array(entry['suggested_use_cases']).map { |u| u.to_s.strip.downcase }.reject(&:blank?).uniq,
        brandability_score: clamp_unit(entry['brandability_score']),
        confidence: clamp_unit(entry['confidence']),
        classification_source: DomainClassification::OPENAI_SOURCE,
        classification_model: openai_model,
        classified_at: Time.current,
        raw_llm_response: { entry: entry, batch_response_excerpt: raw_response['classifications']&.size }
      }
    end

    def sanitize_categories(values)
      Array(values)
        .map { |v| v.to_s.strip.downcase }
        .select { |v| Recommendation::InterestCatalog.categories.include?(v) }
        .uniq
    end

    def sanitize_category(value)
      cleaned = value.to_s.strip.downcase
      Recommendation::InterestCatalog.categories.include?(cleaned) ? cleaned : nil
    end

    def sanitize_locale(value)
      DESCRIPTION_LOCALES.include?(value) ? value : 'en'
    end

    def clamp_unit(value)
      return nil if value.nil?

      value.to_f.clamp(0.0, 1.0).round(3)
    end
  end
end
