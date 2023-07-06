class ActiveAuctionsAiSortingJob < ApplicationJob
  retry_on StandardError, wait: 5.seconds, attempts: 3

  MODEL = 'gpt-3.5-turbo'.freeze

  def perform
    return unless self.class.needs_to_run?

    auctions_list = Auction.active
    ai_response = fetch_ai_response(auctions_list)
    process_ai_response(ai_response)
  rescue OpenAI::Error => e
    handle_openai_error(e)
  end

  def self.needs_to_run?
    Feature.open_ai_integration_enabled?
  end

  private

  def system_message
    Setting.find_by(code: 'openai_domains_evaluation_prompt').retrieve
  end

  def handle_openai_error(error)
    Rails.logger.info "OpenAI API error: #{error.message}"
  end

  def process_ai_response(response)
    Rails.logger.info "AI response received: #{response}"
    parsed_response = JSON.parse(response)
    ai_scores = parsed_response.map { |item| { id: item['id'], ai_score: item['ai_score'] } }

    update_auctions_with_ai_scores(ai_scores)
  end

  def fetch_ai_response(auctions_list)
    ai_client = OpenAI::Client.new
    response = ai_client.chat(parameters: chat_parameters(auctions_list))
    ai_response = response.dig('choices', 0, 'message', 'content')
    raise StandardError, response.dig('error', 'message') if ai_response.nil?

    ai_response
  end

  def chat_parameters(auctions_list)
    {
      model: MODEL,
      messages: [
        { role: 'system', content: system_message },
        { role: 'user', content: auctions_list.pluck(:id, :domain_name).to_s },
        { role: 'user', content: 'Response in JSON format: [{id:, domain_name:, ai_score:}]' }
      ]
    }
  end

  def update_auctions_with_ai_scores(ai_scores)
    update_values = ai_scores.map { |score| "WHEN #{score[:id]} THEN #{score[:ai_score]}" }.join(' ')
    update_ids = ai_scores.pluck(:id).join(',')

    sql_query = <<~SQL
      UPDATE auctions
      SET ai_score = CASE id
        #{update_values}
        END
      WHERE id IN (#{update_ids})
    SQL

    ActiveRecord::Base.connection.execute(sql_query)
  end
end
