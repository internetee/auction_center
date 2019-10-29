module BillingHelpers
  extend ActiveSupport::Concern

  def address
    country_name = Countries.name_from_alpha2_code(country_code)
    postal_code_with_city = [postal_code, city].join(' ')
    [street, postal_code_with_city, country_name].compact.join(', ')
  end

  def vat_rate
    if country_code == 'EE'
      Countries.vat_rate_from_alpha2_code(country_code)
    elsif vat_code.present?
      BigDecimal('0')
    else
      # We only supply VAT values for EU countries, otherwise it is always 0.
      Countries.vat_rate_from_alpha2_code(country_code)
    end
  end
end
