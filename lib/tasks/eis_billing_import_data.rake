BASE_URL = AuctionCenter::Application.config
                                        .customization[:billing_system_integration]
                                        &.compact&.fetch(:eis_billing_system_base_url, '')

INITIATOR = 'auction'.freeze

namespace :eis_billing do
  desc 'One time task to export invoice data to billing system'
  task export_invoices: :environment do
    parsed_data = []
    Invoice.all.each do |invoice|
      parsed_data << {
        invoice_number: invoice.number,
        initiator: INITIATOR,
        transaction_amount: invoice.total.to_s,
        status: invoice.status,
        in_directo: invoice.in_directo,
        transaction_time: invoice.paid_at
      }
    end

    base_request(url: import_invoice_data_url, json_obj: parsed_data)
  end
end

def import_invoice_data_url
  "#{BASE_URL}/api/v1/import_data/invoice_data"
end

def base_request(url:, json_obj:)
  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)

  unless Rails.env.development?
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  http.post(url, json_obj.to_json, headers)
end

def self.generate_token
  JWT.encode(payload, billing_secret)
end

def self.payload
  { initiator: INITIATOR }
end

def self.headers
  {
    'Authorization' => "Bearer #{generate_token}",
    'Content-Type' => 'application/json',
  }
end

def self.billing_secret
  AuctionCenter::Application.config.customization[:billing_system_integration]&.compact&.fetch(:billing_secret, '')
end
