class UpdateConstraintsForInvoicesCents < ActiveRecord::Migration[6.1]
  def up
    execute("ALTER TABLE public.invoices DROP CONSTRAINT invoices_cents_are_positive;")
    execute("ALTER TABLE public.invoices ADD CONSTRAINT invoices_cents_are_non_negative CHECK (cents >= 0);")
  end

  def down
    execute("ALTER TABLE public.invoices DROP CONSTRAINT invoices_cents_are_non_negative;")
    execute("ALTER TABLE public.invoices ADD CONSTRAINT invoices_cents_are_positive CHECK (cents > 0);")
  end
end
