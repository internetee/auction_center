class AddPaymentLinkToInvoice < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :payment_link, :string if Feature.billing_system_integration_enabled?
  end
end
