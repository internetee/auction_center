class DirectoInvoiceForwardJob < ApplicationJob
  def perform
    collected_data = []
    invoices = Invoice.where(status: 'paid', in_directo: false)
    return unless invoices.any?

    invoices.each do |i|
      collected_data << i.as_directo_json
    end

    EisBilling::SendDataToDirectoService.call(object_data: collected_data)
  end

  def self.needs_to_run?
    Setting.find_by(code: 'directo_integration_enabled').retrieve
  end
end
