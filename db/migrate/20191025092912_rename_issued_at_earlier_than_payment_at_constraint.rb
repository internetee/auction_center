class RenameIssuedAtEarlierThanPaymentAtConstraint < ActiveRecord::Migration[5.2]
  def change
    execute <<~SQL
      ALTER TABLE invoices RENAME CONSTRAINT issued_at_earlier_than_payment_at TO 
      invoices_due_date_is_not_before_issue_date;
    SQL
  end
end
