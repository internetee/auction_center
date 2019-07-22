class AddSuccessfulPaymentOrderReference < ActiveRecord::Migration[5.2]
  def change
    add_reference :invoices, :paid_with_payment_order
  end
end
