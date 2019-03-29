class UpdatePaidInvoicesWithTotalAndVatRate < ActiveRecord::Migration[5.2]
  def up
    invoices = Invoice.where(status: Invoice.statuses[:paid])
                      .where("vat_rate IS NULL and total_amount IS NULL")

    invoices.each do |invoice|
      invoice.vat_rate = invoice.billing_profile.vat_rate
      invoice.total_amount = invoice.total

      invoice.save!
    end
  end

  def down
    # No-op
  end
end
