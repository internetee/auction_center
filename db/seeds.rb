# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

administrator = User.new(given_names: 'Default', surname: 'Administrator',
                         email: 'administrator@auction.test', password: 'password',
                         password_confirmation: 'password', country_code: 'EE',
                         mobile_phone: '+37250060070', identity_code: '51007050118',
                         roles: [User::ADMINISTATOR_ROLE], accepts_terms_and_conditions: true)
administrator.skip_confirmation!
administrator.save

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


terms_and_conditions_description = <<~TEXT.squish
  Link to terms and conditions document. Can be relative ('/public/terms_and_conditions.pdf')
  or absolute ('https://example.com/terms_and_conditions.pdf'). Relative link must start with a
  forward slash. Default is: https://example.com
TEXT
terms_and_conditions_setting = Setting.new(code: :terms_and_conditions_link,
                                           value: "https://example.com",
                                           description: terms_and_conditions_description)
terms_and_conditions_setting.save
