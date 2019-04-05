class AddUpdatedByField < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :updated_by, :string
    add_column :billing_profiles, :updated_by, :string
    add_column :invoices, :updated_by, :string
    add_column :offers, :updated_by, :string
    add_column :settings, :updated_by, :string
    add_column :payment_orders, :updated_by, :string
  end
end
