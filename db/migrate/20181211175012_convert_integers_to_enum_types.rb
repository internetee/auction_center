class ConvertIntegersToEnumTypes < ActiveRecord::Migration[5.2]
  def up
    sql = <<~SQL
      CREATE TYPE invoice_status AS ENUM('issued', 'in_progress', 'paid', 'cancelled');
      CREATE TYPE payment_order_status AS ENUM('issued', 'in_progress', 'paid', 'cancelled');
    SQL

    execute(sql)

    remove_column :invoices, :status
    remove_column :payment_orders, :status
    add_column :invoices, :status, :invoice_status, default: 'issued', index: true
    add_column :payment_orders, :status, :payment_order_status, default: 'issued', index: true
  end

  def down
    remove_column :invoices, :status
    remove_column :payment_orders, :status

    sql = <<~SQL
      DROP TYPE invoice_status;
      DROP TYPE payment_order_status;
    SQL

    execute(sql)
  end
end
