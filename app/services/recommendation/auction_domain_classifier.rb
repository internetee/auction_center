module Recommendation
  class AuctionDomainClassifier
    DEFAULT_TEMPERATURE = 0.2

    class << self
      def call(...)
        new(...).call
      end
    end

    def initialize(auctions:, temperature: DEFAULT_TEMPERATURE)
      @auctions = Array(auctions)
      @temperature = temperature
    end

    def call
      return [] if @auctions.empty?

      response = fetch_ai_response
      classifications = JSON.parse(response).fetch('classifications', [])
      apply_classifications(classifications)
    rescue StandardError, OpenAI::Error => e
      Rails.logger.info "Auction domain classification failed: #{e.message}"
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
        response_format: {
          type: 'json_schema',
          json_schema: schema
        },
        messages: messages
      }.merge(OpenaiStructuredOutputSupport.temperature_options(model_name, @temperature))
    end

    def schema
      {
        name: 'auction_domain_classification',
        schema: {
          type: 'object',
          properties: {
            classifications: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  id: { type: 'number' },
                  domain_name: { type: 'string' },
                  primary_category: { type: 'string' },
                  tags: {
                    type: 'array',
                    items: { type: 'string' }
                  }
                },
                required: %w[id domain_name primary_category tags],
                additionalProperties: false
              }
            }
          },
          required: ['classifications'],
          additionalProperties: false
        },
        strict: true
      }
    end

    def messages
      [
        { role: 'system', content: system_message },
        { role: 'user', content: auctions_payload.to_json }
      ]
    end

    def system_message
      setting = Setting.find_by(code: 'openai_domain_classification_prompt')&.retrieve
      return setting if setting.present?

      <<~PROMPT.squish
        You classify .ee auction domains for a recommendation system.
        For each domain choose one primary category and 1-4 tags from this fixed vocabulary only:
        #{Recommendation::InterestCatalog.categories.join(', ')}.
        Return only categories that are actually inferable from the domain name.
        Prefer conservative classification over guessing.
      PROMPT
    end

    def auctions_payload
      @auctions.map do |auction|
        {
          id: auction.id,
          domain_name: auction.domain_name,
          platform: auction.platform || 'blind',
          starts_at: auction.starts_at,
          ends_at: auction.ends_at
        }
      end
    end

    def openai_model
      OpenaiStructuredOutputSupport.model(Setting.find_by(code: 'openai_model').retrieve)
    end

    def apply_classifications(classifications)
      now = Time.current

      classifications.filter_map do |payload|
        auction = @auctions.find { |item| item.id == payload['id'] }
        next unless auction

        tags = Array(payload['tags']).map(&:to_s).map(&:downcase) & Recommendation::InterestCatalog.categories
        primary_category = payload['primary_category'].to_s.downcase
        primary_category = tags.first if primary_category.blank? || !Recommendation::InterestCatalog.categories.include?(primary_category)

        auction.update_columns(
          classification_tags: tags,
          primary_category: primary_category,
          classification_source: 'openai',
          classification_model: openai_model,
          classified_at: now
        )

        { auction_id: auction.id, tags:, primary_category: }
      end
    end
  end
end
