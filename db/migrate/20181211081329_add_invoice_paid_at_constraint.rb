class AddInvoicePaidAtConstraint < ActiveRecord::Migration[5.2]
  def up
    sql = <<~SQL
      ALTER TABLE public.invoices
      ADD CONSTRAINT paid_at_is_filled_when_status_is_paid
      CHECK (NOT (status = 2 AND paid_at IS NULL));

      ALTER TABLE public.invoices
      ADD CONSTRAINT paid_at_is_not_filled_when_status_is_not_paid
      CHECK (NOT (status <> 2 AND paid_at IS NOT NULL));
    SQL

    execute(sql)
  end

  def down
    sql = <<~SQL
      ALTER TABLE public.invoices DROP CONSTRAINT paid_at_is_filled_when_status_is_paid;
      ALTER TABLE public.invoices DROP CONSTRAINT paid_at_is_not_filled_when_status_is_not_paid;
    SQL

    execute(sql)
  end
end
