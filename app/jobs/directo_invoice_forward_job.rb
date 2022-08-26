class DirectoInvoiceForwardJob < ApplicationJob
  def perform
    collected_data = []
    invoices = Invoice.where(status: 'paid', in_directo: false)
    return unless invoices.any?
    
    invoices.each do |i|
      collected_data << i.as_directo_json
    end

    send_data_to_billing_directo(collected_data)
  end

  def self.needs_to_run?
    Setting.find_by(code: 'directo_integration_enabled').retrieve
  end

  private

  def send_data_to_billing_directo(collected_data)
    result = EisBilling::SendDataToDirecto.send_request(object_data: collected_data)

    Rails.logger.info '---------'
    Rails.logger.info result
    Rails.logger.info '---------'

    result
  end
end
