namespace :invoices do
  desc 'One time task to export invoice data to billing system'
  task send_amount_to_billing: :environment do
    invoices = Invoice.issued

    invoices.each do |invoice|
      EisBilling::UpdateInvoiceDataService.call(invoice_number: invoice.number, transaction_amount: invoice.total.to_f)
    end
  end
end
