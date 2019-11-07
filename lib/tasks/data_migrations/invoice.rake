namespace :data_migrations do
  desc 'Copy associated BillingProfile address to Invoice'
  task populate_billing_fields: :environment do
    @invoices = Invoice.all
    migrated_invoice_count = 0
    failed_invoices = []

    @invoices.each do |invoice|
      next if invoice.billing_profile.blank?
      next unless invoice.recipient.nil?

      fields = %w[vat_code street city state postal_code alpha_two_country_code]
      invoice.recipient = invoice.billing_profile.name

      invoice.billing_profile.attributes.keys.each do |attribute|
        invoice[attribute] = invoice.billing_profile[attribute] if fields.include? attribute
      end

      if invoice.save
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
end
