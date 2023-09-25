class PopulateBillingFields < ActiveRecord::Migration[6.0]
  def up
    puts 'Copy associated BillingProfile address to Invoice'
    @invoices = Invoice.all
    migrated_invoice_count = 0
    failed_invoices = []

    @invoices.each do |invoice|
      next if invoice.billing_profile.blank?
      next unless invoice.recipient.nil?

      if invoice.update_billing_info && invoice.save
        migrated_invoice_count += 1
      else
        failed_invoices << invoice.id
      end
    end

    puts "Migrated #{migrated_invoice_count} invoices."
    if failed_invoices.any?
      puts "Failed to migrate #{failed_invoices.count} invoices."
      puts "Failed invoice id's = #{failed_invoices}"
    end
  end

  def down
  end
end
