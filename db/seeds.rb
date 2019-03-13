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
                         roles: [User::ADMINISTATOR_ROLE], accepts_terms_and_conditions: true)
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

# Terms and condition link
terms_and_conditions_description = <<~TEXT.squish
  Link to terms and conditions document. Can be relative ('/public/terms_and_conditions.pdf')
  or absolute ('https://example.com/terms_and_conditions.pdf'). Relative link must start with a
  forward slash. Default is: https://example.com
TEXT
terms_and_conditions_setting = Setting.new(code: :terms_and_conditions_link,
                                           value: "https://example.com",
                                           description: terms_and_conditions_description)
terms_and_conditions_setting.save

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

# Default registration term
registration_term_description = <<~TEXT.squish
      Number of days before the auctioned domain must be registered, starting from
      the auction start. Default: 14
    TEXT

registration_term_setting = Setting.new(code: :registration_term, value: '14',
                                        description: registration_term_description)

registration_term_setting.save

# Default auction duration
auction_duration_description = <<~TEXT.squish
      Number of hours for which an auction is created. You can also use 'end_of_day'
      for auctions to end at the end of the same calendar day. Default: 24.
    TEXT

auction_duration_setting = Setting.new(code: :auction_duration, value: '24',
                                       description: auction_duration_description)

auction_duration_setting.save

# Default require phone confirmation
phone_confirmation_description = <<~TEXT.squish
      Require mobile numbers to be confirmed by SMS before user can place offers. Can be either 'true'
      or 'false'
    TEXT

phone_confirmation_setting = Setting.new(code: :require_phone_confirmation,
                                         value: 'false',
                                         description: phone_confirmation_description)

phone_confirmation_setting.save

# Default auction starts at
auctions_start_at_description = <<~TEXT.squish
      Whole hour at which auctions should start. Allowed values are anything between 0 and 23 or
      'false'. In case 'false' is used, auctions are started as soon as possible.
    TEXT

auctions_start_at_setting = Setting.new(code: :auctions_start_at, value: '0',
                                        description: auctions_start_at_description)

auctions_start_at_setting.save

# Default long ban length
ban_length_description = <<~TEXT.squish
      Number of months for which a repeated offender is banned for. Default: 100
    TEXT

ban_length_setting = Setting.new(code: :ban_length, value: '100',
                                 description: ban_length_description)

ban_length_setting.save

# Default domain registration reminder time
domain_registration_description = <<~TEXT.squish
      Number of days before which the registration reminder email is sent on. Default: 5
    TEXT

domain_registration_setting = Setting.new(code: :domain_registration_reminder, value: '5',
                                          description: domain_registration_description)

domain_registration_setting.save
