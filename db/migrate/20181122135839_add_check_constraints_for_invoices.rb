class AddCheckConstraintsForInvoices < ActiveRecord::Migration[5.2]
  def up
    sql = <<~SQL
      ALTER TABLE public.invoices
      ADD CONSTRAINT issued_at_earlier_than_payment_at CHECK (issued_at <= payment_at);
    SQL

    execute(sql)
  end

  def down
    sql = <<~SQL
      ALTER TABLE public.invoices DROP CONSTRAINT issued_at_earlier_than_payment_at;
    SQL

    execute(sql)
  end
end
