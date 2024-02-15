namespace :invoices do
  desc 'Assign vat rate to invoices what have vat rate of nil'
  task assign_invoices_vat_rate: :environment do
    Invoice.where(vat_rate: [nil, 0.0], country_code: 'EE').in_batches do |batch_invoices|
      batch_invoices.where('created_at < ?', '2024-01-01').update_all(vat_rate: 0.2)
      batch_invoices.where('created_at >= ?', '2024-01-01').update_all(vat_rate: 0.22)
    end

    Invoice.where(vat_rate: nil).where.not(vat_code: nil).in_batches do |batch_invoices|
      batch_invoices.update_all(vat_rate: 0.0)
    end

    Invoice.where.not(country_code: 'EE').where(vat_rate: nil).in_batches do |batch_invoices|
      batch_invoices.each do |invoice|
        invoice.update(vat_rate: Countries.vat_rate_from_alpha2_code(invoice.country_code))
      end
    end
  end

  task assign_values_to_old_invoices: :environment do
    Invoice.where('created_at < ?', '2024-01-01').where(country_code: 'EE', vat_rate: 0.22)
           .update_all(vat_rate: 0.2, in_directo: false)
  end
end
