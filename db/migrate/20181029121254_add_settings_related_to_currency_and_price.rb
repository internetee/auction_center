class AddSettingsRelatedToCurrencyAndPrice < ActiveRecord::Migration[5.2]
  def up
    currency_description = <<~TEXT.squish
      Currency in which all invoices and offers are to be made. Allowed values are
      EUR, USD, CAD, AUD, GBP, PLN, SEK. Default is: EUR
    TEXT

    currency_setting = Setting.new(code: :auction_currency, value: 'EUR',
                                   description: currency_description)

    currency_setting.save

    auction_minimum_offer = Setting.new(
      code: :auction_minimum_offer,
      value: '500',
      description:
      'Minimum amount in cents that a user can offer for a domain. Default is: 500 (5.00 EUR)'
    )

    auction_minimum_offer.save
  end

  def down
    Setting.where(code: [:auction_currency, :auction_minimum_offer]).delete_all
  end
end
