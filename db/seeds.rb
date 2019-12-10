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
  Link to terms and conditions document. Must be single parsable hash of <locale>:<URL> elements.
        URL can be relative ('/public/terms_and_conditions.pdf')
        or absolute ('https://example.com/terms_and_conditions.pdf'). Relative URL must start with a
        forward slash. Default is: "{\"en\":\"https://example.com\", \"et\":\"https://example.et\"}"
TEXT
terms_and_conditions_setting = Setting.new(code: :terms_and_conditions_link,
                                           value: "{\"en\":\"https://example.com\", \"et\":\"https://example.et\"}",
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
  Number of full days after the issue date the recipient has time to pay for the invoice.
  If invoices are generated at the start of a day you might want to substract 1 from the
  setting to achieve desired invoice due date. Default: 7
TEXT

payment_term_setting = Setting.new(code: :payment_term, value: '7',
                                   description: payment_term_description)

payment_term_setting.save

# Default registration term
registration_term_description = <<~TEXT.squish
  Number of days before the auctioned domain must be registered, starting from release of
  registration code. Default: 14
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

# Default number of ban strikes
ban_number_of_strikes_description = <<~TEXT.squish
  Number of strikes (unpaid invoices) at which a long ban is applied. Default: 3
TEXT

ban_number_of_strikes_setting = Setting.new(code: :ban_number_of_strikes, value: '3',
                                            description: ban_number_of_strikes_description)

ban_number_of_strikes_setting.save

# Link to auction regulations on strikes
violations_count_regulations_description = <<~TEXT.squish
  Link to ToC clause on user agreement termination, used in ban message banner.
  Must be parsable string containing hash of <locale>:<URL> elements.
  URL can be relative ('/public/terms_and_conditions.pdf')
  or absolute ('https://example.com/terms_and_conditions.pdf'). Relative URL must start with a
  forward slash.
  Default: "{\"en\":\"https://example.com#some_anchor\"}"
TEXT

violations_count_regulations_setting = Setting.new(code: :violations_count_regulations_link,
                                            value: "{\"en\":\"https://example.com#some_anchor\"}",
                                            description: violations_count_regulations_description)

violations_count_regulations_setting.save!


# Default domain registration reminder time
domain_registration_description = <<~TEXT.squish
  Number of days before which the registration reminder email is sent on. Default: 5
TEXT

domain_registration_setting = Setting.new(code: :domain_registration_reminder, value: '5',
                                          description: domain_registration_description)

domain_registration_setting.save

# Default invoice issuer
invoice_issuer_description = <<~TEXT.squish
      Text that should appear in invoice as issuer. Usually contains company name, VAT number and
      local court registration number.
    TEXT

invoice_issuer_value = <<~TEXT.squish
      Eesti Interneti SA Paldiski mnt 80, Tallinn, Harjumaa, 10617 Estonia,
      Reg. no 90010019, VAT number EE101286464
    TEXT

invoice_issuer_setting = Setting.new(code: :invoice_issuer, value: invoice_issuer_value,
                                     description: invoice_issuer_description)

invoice_issuer_setting.save

# Default invoice reminder
invoice_reminder_description = <<~TEXT.squish
  Number of days before due date on which reminders about unpaid invoices are sent.
  Use 0 to send reminders on due date. Default: 1
TEXT

invoice_reminder_setting = Setting.new(code: :invoice_reminder_in_days, value: '1',
                                       description: invoice_reminder_description)

invoice_reminder_setting.save


# Default wishlist size
wishlist_size_description = <<~TEXT.squish
  Number of domains a single user can keep in their wishlist. Default: 10
TEXT

wishlist_size_setting = Setting.new(code: :wishlist_size, value: '10',
                                    description: wishlist_size_description)
wishlist_size_setting.save

# Wishlist allowed domain extensions
domain_extensions_description = <<~TEXT.squish
  Supported domain extensions for wishlist domain monitoring.
TEXT

extensions = ['ee', 'pri.ee', 'com.ee', 'med.ee', 'fie.ee']

domain_extensions = Setting.new(code: :wishlist_supported_domain_extensions, value: extensions,
                                    description: domain_extensions_description)
domain_extensions.save

check_api_url_description = <<~TEXT.squish,
          URL to our own auction API endpoint for health checking.
          Must be absolute, default is http://localhost/auctions.json.
TEXT

check_api_url_value = 'http://localhost/auctions.json'

check_api_url = Setting.new(code: :check_api_url,
                            value: check_api_url_value,
                            description: check_api_url_description)

check_api_url.save!

check_sms_url_description = <<~TEXT.squish,
          URL of SMS service provider for health checking.
          Must be absolute.
TEXT

check_sms_url_value = 'https://status.messente.com/api/v1/components/1'

check_sms_url = Setting.new(code: :check_sms_url,
                            value: check_sms_url_value,
                            description: check_sms_url_description)

check_sms_url.save!

check_tara_url_description = <<~TEXT.squish,
          URL of OAUTH Tara provider for health checking.
          Must be absolute.
TEXT

check_tara_url_value = 'https://tara-test.ria.ee/oidc/jwks'

check_tara_url = Setting.new(code: :check_tara_url,
                            value: check_tara_url_value,
                            description: check_tara_url_description)

check_tara_url.save!
