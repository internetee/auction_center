class AddInvoiceNumberAsSequence < ActiveRecord::Migration[5.2]
  def up
    sql = <<~SQL
      CREATE SEQUENCE public.invoices_number_seq
      START WITH 1
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      CACHE 1;
    SQL

    execute(sql)

    add_column :invoices, :number, :integer, null: false,
      default: -> { "nextval('invoices_number_seq')" }

    sql = <<~SQL
      ALTER SEQUENCE public.invoices_number_seq OWNED BY public.invoices.number;
    SQL

    execute(sql)
  end

  def down
    remove_column :invoices, :number
  end
end
