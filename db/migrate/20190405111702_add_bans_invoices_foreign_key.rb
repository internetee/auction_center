class AddBansInvoicesForeignKey < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :bans, :invoices
  end
end
