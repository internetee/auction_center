class CaptureJob < ApplicationJob
  BASE_URL = AuctionCenter::Application.config
                                       .customization[:billing_system_integration]
    &.compact&.fetch(:eis_billing_system_base_url, '')
  PATH = '/api/v1/refund/capture'.freeze
  INITIATOR = 'auction'.freeze
  PAID = 'paid'.freeze

  def perform(domain_participate_auction_id, invoice_number)
    response = post(PATH, params: { invoice_number: })
    d = DomainParticipateAuction.find(domain_participate_auction_id)

    if response.status == 200
      d.update(status: PAID)
    else
      inform(d, response.body)
    end

    JSON.parse response.body
  end

  def inform(domain_participate_auction, error_message)
    admin_emails = User.where(roles: ['administrator']).pluck(:email)

    InvoiceMailer.refund_failed(admin_emails, domain_participate_auction.auction, domain_participate_auction.user,
                                error_message).deliver_later
    Rails.logger.info error_message
  end

  def post(path, params = {})
    connection.post(path, JSON.dump(params))
  end

  def connection
    Faraday.new(options) do |faraday|
      faraday.adapter Faraday.default_adapter
    end
  end

  private

  def options
    {
      headers: {
        'Authorization' => "Bearer #{generate_token}",
        'Content-Type' => 'application/json'
      },
      url: BASE_URL
    }
  end

  def generate_token
    JWT.encode(payload, billing_secret)
  end

  def payload
    { initiator: INITIATOR }
  end

  def billing_secret
    AuctionCenter::Application.config.customization[:billing_system_integration]&.compact&.fetch(:billing_secret, '')
  end
end
