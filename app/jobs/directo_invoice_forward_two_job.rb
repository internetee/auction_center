class DirectoInvoiceForwardTwoJob < ApplicationJob
  def perform
    collected_data = []

    invoices = Invoice.where(status: 'paid', in_directo: false)
    return unless invoices.any?

    invoices.each do |i|
      collected_data << i.as_directo_json
    end

    EisBilling::SendDataToDirecto.send_request(object_data: collected_data)
  end
end
