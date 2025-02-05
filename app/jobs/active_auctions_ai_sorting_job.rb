# frozen_string_literal: true

class ActiveAuctionsAiSortingJob < ApplicationJob
  retry_on StandardError, wait: 5.seconds, attempts: 3

  DEFAULT_TEMPERATURE = 0.7

  def perform(temperature = DEFAULT_TEMPERATURE)
    return unless self.class.needs_to_run?

    auctions_list = Auction.active_with_offers_count
    ai_response = fetch_ai_response(auctions_list, temperature)
    process_ai_response(ai_response)
  rescue StandardError, OpenAI::Error => e
    handle_openai_error(e)
  end

  def self.needs_to_run?
    Feature.open_ai_integration_enabled?
  end

  private

  def handle_openai_error(error)
    Rails.logger.info "OpenAI API error: #{error.message}"
  end

  def process_ai_response(response)
    Rails.logger.info "AI response received: #{response}"
    parsed_response = JSON.parse(response)
    ai_scores = parsed_response['scores'].map { |item| { id: item['id'], ai_score: item['ai_score'] } }

    update_auctions_with_ai_scores(ai_scores)
  end

  def fetch_ai_response(auctions_list, temperature)
    ai_client = OpenAI::Client.new
    response = ai_client.chat(parameters: chat_parameters(auctions_list, temperature))

    finish_reason = response.dig('choices', 0, 'finish_reason')
    raise StandardError, 'Incomplete response' if finish_reason && finish_reason == 'length'

    refusal = response.dig('choices', 0, 'message', 'refusal')
    raise StandardError, refusal if refusal

    content = response.dig('choices', 0, 'message', 'content')
    raise StandardError, response.dig('error', 'message') || 'No response content' if content.nil?

    content
  end

  def chat_parameters(auctions_list, temp)
    {
      model: openai_model,
      response_format: {
        type: 'json_schema',
        json_schema: schema
      },
      messages: messages(auctions_list),
      temperature: temp
    }
  end

  # rubocop:disable Metrics/MethodLength
  def schema
    {
      name: 'ai_response',
      schema: {
        type: 'object',
        properties: {
          scores: {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                id: { type: 'number' },
                domain_name: { type: 'string' },
                ai_score: { type: 'number' }
              },
              required: %w[id domain_name ai_score],
              additionalProperties: false
            }
          }
        },
        required: ['scores'],
        additionalProperties: false
      },
      strict: true
    }
  end
  # rubocop:enable Metrics/MethodLength

  def messages(auctions_list)
    [
      { role: 'system', content: system_message },
      { role: 'user', content: format(auctions_list) }
    ]
  end

  def format(auctions_list)
    auctions_list.map do |a|
      sliced = a.attributes.slice('id', 'domain_name')
      if a.platform != 'english'
        sliced.merge!({ last_offer: 0, offers_count: 0 })
      else
        sliced.merge!({ last_offer: a.cents, offers_count: a.offers_count })
      end
      sliced
    end.to_json
  end

  def update_auctions_with_ai_scores(ai_scores)
    ai_scores.each_slice(500) do |batch|
      # rubocop:disable Rails/SkipsModelValidations
      # Using update_all for performance reasons as ai_score doesn't require validations
      # and we need to update large number of records efficiently
      Auction.where(id: batch.pluck(:id))
             .update_all(
               sanitize_update_statement(batch)
             )
      # rubocop:enable Rails/SkipsModelValidations
    end
  end

  def sanitize_update_statement(batch)
    # Using sanitize_sql_array to prevent SQL injection
    ActiveRecord::Base.sanitize_sql_array([
                                            "ai_score = CASE id #{sanitize_case_statement(batch)} END"
                                          ])
  end

  def sanitize_case_statement(scores)
    scores.map do |score|
      ActiveRecord::Base.sanitize_sql_array([
                                              'WHEN ? THEN ?',
                                              score[:id],
                                              score[:ai_score]
                                            ])
    end.join(' ')
  end

  def system_message
    Setting.find_by(code: 'openai_domains_evaluation_prompt').retrieve
  end

  def openai_model
    Setting.find_by(code: 'openai_model').retrieve
  end
end
