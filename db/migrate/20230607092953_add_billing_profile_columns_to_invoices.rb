class AddBillingProfileColumnsToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :billing_name, :string, null: false, default: ''
    add_column :invoices, :billing_address, :string, null: false, default: ''
    add_column :invoices, :billing_vat_code, :string, null: true
    add_column :invoices, :billing_alpha_two_country_code, :string, null: false, default: ''
  end
end
