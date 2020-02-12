class CreateInvoicePaymentOrder < ActiveRecord::Migration[6.0]
  def up
    create_table :invoice_payment_orders do |t|
      t.references :invoice, null: false
      t.references :payment_order, null: false
    end

    PaymentOrder.all.each do |order|
      InvoicePaymentOrder.create(invoice_id: order.invoice_id, payment_order_id: order.id)
    end
  end

  def down
    drop_table :invoice_payment_orders
  end
end
