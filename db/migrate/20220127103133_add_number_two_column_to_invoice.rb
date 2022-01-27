class AddNumberTwoColumnToInvoice < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :number_two, :integer

    puts 'Updating correctly named columns'
    execute "UPDATE invoices SET number_two = number"
  end
end
