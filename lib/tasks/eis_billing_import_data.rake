BASE_URL = ""
if Rails.env.staging?
  BASE_URL = AuctionCenter::Application.config
                                             .customization[:billing_system_integration]
                                             &.compact&.fetch(:eis_billing_system_base_url_staging, '')
else
  BASE_URL = AuctionCenter::Application.config
                                             .customization[:billing_system_integration]
                                             &.compact&.fetch(:eis_billing_system_base_url_dev, '')
end

INITIATOR = 'auction'

SECRET_WORD = AuctionCenter::Application.config
                                          .customization[:billing_system_integration]
                                          &.compact&.fetch(:secret_word, '')
SECRET_ACCESS_WORD = AuctionCenter::Application.config
                                                  .customization[:billing_system_integration]
                                                  &.compact&.fetch(:secret_access_word, '')

namespace :eis_billing do
  desc 'One time task to export invoice data to billing system'
  task import_invoices: :environment do
    parsed_data = []
    Invoice.all.each do |invoice|
      parsed_data << {
        invoice_number: invoice.number,
        initiator: INITIATOR,
        transaction_amount: invoice.total.to_s
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

def generate_token
  JWT.encode(payload, SECRET_WORD)
end

def payload
  { data: SECRET_ACCESS_WORD }
end

def headers 
  {
  'Authorization' => "Bearer #{generate_token}",
  'Content-Type' => 'application/json'
  }
end
