require 'audit_migration'

class CreateInvoicePaymentOrder < ActiveRecord::Migration[6.0]
  def up
    create_table :invoice_payment_orders do |t|
      t.references :invoice, null: false
      t.references :payment_order, null: false
    end

    change_column_null :payment_orders, :invoice_id, true

    PaymentOrder.all.each do |order|
      InvoicePaymentOrder.create(invoice_id: order.invoice_id, payment_order_id: order.id)
    end

    migration = AuditMigration.new('invoice_payment_order')
    execute(migration.create_table)
    execute(migration.create_trigger)
  end

  def down
    drop_table :invoice_payment_orders
    migration = AuditMigration.new('invoice_payment_order')
    execute(migration.drop)
  end
end
