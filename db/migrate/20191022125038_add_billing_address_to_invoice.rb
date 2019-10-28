class AddBillingAddressToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :recipient, :string
    add_column :invoices, :vat_code, :string
    add_column :invoices, :legal_entity, :boolean
    add_column :invoices, :street, :string
    add_column :invoices, :city, :string
    add_column :invoices, :state, :string
    add_column :invoices, :postal_code, :string
    add_column :invoices, :alpha_two_country_code, :string
  end
end
