# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Administrator (initial user)
administrator = User.new(given_names: 'Default', surname: 'Administrator',
                         email: 'administrator@auction.test', password: 'password',
                         password_confirmation: 'password', country_code: 'EE',
                         mobile_phone: '+37250060070', identity_code: '51007050118',
                         roles: [User::ADMINISTATOR_ROLE])

administrator.skip_confirmation!
administrator.save

# Currency
currency_description = <<~TEXT.squish
  Currency in which all invoices and offers are to be made. Allowed values are
  EUR, USD, CAD, AUD, GBP, PLN, SEK. Default is: EUR
TEXT
currency_setting = Setting.new(code: :auction_currency, value: 'EUR',
                               description: currency_description)
currency_setting.save

# Minimum offer for the auction
auction_minimum_offer = Setting.new(
  code: :auction_minimum_offer,
  value: '500',
  description:
  'Minimum amount in cents that a user can offer for a domain. Default is: 500 (5.00 EUR)'
)
auction_minimum_offer.save

# Default country
default_country_description = <<~TEXT.squish
      Alpha two code for default country, used for example in user and billing profile dropdowns.
      Example values: "EE", "GB", "US", "CA"
    TEXT

default_country_setting = Setting.new(code: :default_country, value: 'EE',
                                      description: default_country_description)
default_country_setting.save

# Default payment term
payment_term_description = <<~TEXT.squish
      Number of days before which an invoice for auction must be paid. Default: 7
    TEXT

payment_term_setting = Setting.new(code: :payment_term, value: '7',
                                   description: payment_term_description)

payment_term_setting.save
