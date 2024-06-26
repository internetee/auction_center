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
                               description: currency_description, value_format: 'string')
currency_setting.save

# Minimum offer for the auction
auction_minimum_offer = Setting.new(
  code: :auction_minimum_offer,
  value: '500',
  description:
  'Minimum amount in cents that a user can offer for a domain. Default is: 500 (5.00 EUR)',
  value_format: 'integer'
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
                                           value: '{"en":"https://example.com", "et":"https://example.et"}',
                                           description: terms_and_conditions_description,
                                           value_format: 'hash')
terms_and_conditions_setting.save

# Default country
default_country_description = <<~TEXT.squish
  Alpha two code for default country, used for example in user and billing profile dropdowns.
  Example values: "EE", "GB", "US", "CA"
TEXT

default_country_setting = Setting.new(code: :default_country, value: 'EE',
                                      description: default_country_description,
                                      value_format: 'string')
default_country_setting.save

# Default payment term
payment_term_description = <<~TEXT.squish
  Number of full days after the issue date the recipient has time to pay for the invoice.
  If invoices are generated at the start of a day you might want to substract 1 from the
  setting to achieve desired invoice due date. Default: 7
TEXT

payment_term_setting = Setting.new(code: :payment_term, value: '7',
                                   description: payment_term_description,
                                   value_format: 'integer')

payment_term_setting.save

# Default registration term
registration_term_description = <<~TEXT.squish
  Number of days before the auctioned domain must be registered, starting from release of
  registration code. Default: 14
TEXT

registration_term_setting = Setting.new(code: :registration_term, value: '14',
                                        description: registration_term_description,
                                        value_format: 'integer')

registration_term_setting.save

# English auction default registration term
registration_english_auction_term_description = <<~TEXT.squish
  Number of days before the auctioned domain in english type of auction must be registered, starting from release of
  registration code. Default: 30
TEXT

registration_english_term_setting = Setting.new(code: :registration_english_term, value: '30',
                                                description: registration_english_auction_term_description,
                                                value_format: 'integer')

registration_english_term_setting.save

# Default auction duration
auction_duration_description = <<~TEXT.squish
  Number of hours for which an auction is created. You can also use 'end_of_day'
  for auctions to end at the end of the same calendar day. Default: 24.
TEXT

auction_duration_setting = Setting.new(code: :auction_duration, value: '24',
                                       description: auction_duration_description,
                                       value_format: 'string')

auction_duration_setting.save

# Default require phone confirmation
phone_confirmation_description = <<~TEXT.squish
  Require mobile numbers to be confirmed by SMS before user can place offers. Can be either 'true'
  or 'false'
TEXT

phone_confirmation_setting = Setting.new(code: :require_phone_confirmation,
                                         value: 'false',
                                         description: phone_confirmation_description,
                                         value_format: 'boolean')

phone_confirmation_setting.save

# Default auction starts at
auctions_start_at_description = <<~TEXT.squish
  Whole hour at which auctions should start. Allowed values are anything between 0 and 23 or
  'false'. In case 'false' is used, auctions are started as soon as possible.
TEXT

auctions_start_at_setting = Setting.new(code: :auctions_start_at, value: '0',
                                        description: auctions_start_at_description,
                                        value_format: 'string')

auctions_start_at_setting.save

# Default long ban length
ban_length_description = <<~TEXT.squish
  Number of months for which a repeated offender is banned for. Default: 100
TEXT

ban_length_setting = Setting.new(code: :ban_length, value: '100',
                                 description: ban_length_description,
                                 value_format: 'integer')

ban_length_setting.save

# Default number of ban strikes
ban_number_of_strikes_description = <<~TEXT.squish
  Number of strikes (unpaid invoices) at which a long ban is applied. Default: 3
TEXT

ban_number_of_strikes_setting = Setting.new(code: :ban_number_of_strikes, value: '3',
                                            description: ban_number_of_strikes_description,
                                            value_format: 'integer')

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
                                                   value: '{"en":"https://example.com#some_anchor"}',
                                                   description: violations_count_regulations_description,
                                                   value_format: 'hash')

violations_count_regulations_setting.save

# Default domain registration reminder time
domain_registration_description = <<~TEXT.squish
  Number of days before which the registration reminder email is sent on. Default: 5
TEXT

domain_registration_setting = Setting.new(code: :domain_registration_reminder, value: '5',
                                          description: domain_registration_description,
                                          value_format: 'integer')

domain_registration_setting.save

# Default invoice issuer
invoice_issuer_description = <<~TEXT.squish
  Text that should appear in invoice as issuer. Usually contains a company name.
TEXT

invoice_issuer_value = <<~TEXT.squish
  Eesti Interneti SA
TEXT

invoice_issuer_setting = Setting.new(code: :invoice_issuer, value: invoice_issuer_value,
                                     description: invoice_issuer_description,
                                     value_format: 'string')

invoice_issuer_setting.save

# Default issuer address
invoice_issuer_address_description = <<~TEXT.squish
  Default issuer address
TEXT

invoice_issuer_address_value = <<~TEXT.squish
  Paldiski mnt 80, Tallinn, Harjumaa, 10617 Estonia,
TEXT

invoice_issuer_address_setting = Setting.new(code: :invoice_issuer_address, value: invoice_issuer_address_value,
                                             description: invoice_issuer_address_description,
                                             value_format: 'string')

invoice_issuer_address_setting.save

# Default issuer reg no
invoice_issuer_reg_no_description = <<~TEXT.squish
  Default issuer reg no
TEXT

invoice_issuer_reg_no_value = <<~TEXT.squish
  90010019
TEXT

invoice_issuer_reg_no_setting = Setting.new(code: :invoice_issuer_reg_no, value: invoice_issuer_reg_no_value,
                                            description: invoice_issuer_reg_no_description,
                                            value_format: 'string')

invoice_issuer_reg_no_setting.save

# Default invoice issuer VAT no
invoice_issuer_reg_no_setting.save

# Default issuer vat number
invoice_issuer_vat_no_description = <<~TEXT.squish
  Default issuer vat number
TEXT

invoice_issuer_vat_no_value = <<~TEXT.squish
  EE101286464
TEXT

invoice_issuer_vat_no_setting = Setting.new(code: :invoice_issuer_vat_no, value: invoice_issuer_vat_no_value,
                                            description: invoice_issuer_vat_no_description,
                                            value_format: 'string')

invoice_issuer_vat_no_setting.save

# Default invoice issuer street name
invoice_issuer_street_description = <<~TEXT.squish
  Invoice issuer street name.
TEXT

invoice_issuer_street_value = <<~TEXT.squish
  Paldiski mnt 80
TEXT

invoice_issuer_street_setting = Setting.new(code: :invoice_issuer_street, value: invoice_issuer_street_value,
                                            description: invoice_issuer_street_description,
                                            value_format: 'string')

invoice_issuer_street_setting.save

# Default invoice issuer state name
invoice_issuer_state_description = <<~TEXT.squish
  Invoice issuer state name.
TEXT

invoice_issuer_state_value = <<~TEXT.squish
  Harjumaa
TEXT

invoice_issuer_state_setting = Setting.new(code: :invoice_issuer_state, value: invoice_issuer_state_value,
                                           description: invoice_issuer_state_description,
                                           value_format: 'string')

invoice_issuer_state_setting.save

# Default invoice issuer postal code
invoice_issuer_zip_description = <<~TEXT.squish
  Invoice issuer zip code.
TEXT

invoice_issuer_zip_value = <<~TEXT.squish
  10617
TEXT

invoice_issuer_zip_setting = Setting.new(code: :invoice_issuer_zip, value: invoice_issuer_zip_value,
                                         description: invoice_issuer_zip_description,
                                         value_format: 'string')

invoice_issuer_zip_setting.save

# Default invoice issuer city name
invoice_issuer_city_description = <<~TEXT.squish
  Invoice issuer city name.
TEXT

invoice_issuer_city_value = <<~TEXT.squish
  10617
TEXT

invoice_issuer_city_setting = Setting.new(code: :invoice_issuer_city, value: invoice_issuer_city_value,
                                          description: invoice_issuer_city_description,
                                          value_format: 'string')

invoice_issuer_city_setting.save

# Default invoice issuer country code
invoice_issuer_country_code_description = <<~TEXT.squish
  Invoice issuer country code.
TEXT

invoice_issuer_country_code_value = <<~TEXT.squish
  EE
TEXT

invoice_issuer_country_code_setting = Setting.new(code: :invoice_issuer_country_code, value: invoice_issuer_country_code_value,
                                                  description: invoice_issuer_country_code_description,
                                                  value_format: 'string')

invoice_issuer_country_code_setting.save

invoice_issuer_vat_no_setting = Setting.new(code: :invoice_issuer_vat_number, value: invoice_issuer_vat_no_value,
                                            description: invoice_issuer_vat_no_description,
                                            value_format: 'string')

invoice_issuer_vat_no_setting.save

# Default invoice reminder
invoice_reminder_description = <<~TEXT.squish
  Number of days before due date on which reminders about unpaid invoices are sent.
  Use 0 to send reminders on due date. Default: 1
TEXT

invoice_reminder_setting = Setting.new(code: :invoice_reminder_in_days, value: '1',
                                       description: invoice_reminder_description,
                                       value_format: 'integer')

invoice_reminder_setting.save

# Default wishlist size
wishlist_size_description = <<~TEXT.squish
  Number of domains a single user can keep in their wishlist. Default: 10
TEXT

wishlist_size_setting = Setting.new(code: :wishlist_size, value: '10',
                                    description: wishlist_size_description,
                                    value_format: 'integer')
wishlist_size_setting.save

# Wishlist allowed domain extensions
domain_extensions_description = <<~TEXT.squish
  Supported domain extensions for wishlist domain monitoring.
TEXT

extensions = ['ee', 'pri.ee', 'com.ee', 'med.ee', 'fie.ee']

domain_extensions = Setting.new(code: :wishlist_supported_domain_extensions, value: extensions,
                                description: domain_extensions_description,
                                value_format: 'array')
domain_extensions.save

check_api_url_description = <<~TEXT.squish
  URL to our own auction API endpoint for health checking.
  Must be absolute, default is http://localhost/auctions.json.
TEXT

check_api_url_value = 'http://localhost/auctions.json'

check_api_url = Setting.new(code: :check_api_url,
                            value: check_api_url_value,
                            description: check_api_url_description,
                            value_format: 'string')

check_api_url.save

check_sms_url_description = <<~TEXT.squish
  URL of SMS service provider for health checking.
  Must be absolute.
TEXT

check_sms_url_value = 'https://status.messente.com/api/v1/components/1'

check_sms_url = Setting.new(code: :check_sms_url,
                            value: check_sms_url_value,
                            description: check_sms_url_description,
                            value_format: 'string')

check_sms_url.save

check_tara_url_description = <<~TEXT.squish
  URL of OAUTH Tara provider for health checking.
  Must be absolute.
TEXT

check_tara_url_value = 'https://tara-test.ria.ee/oidc/jwks'

check_tara_url = Setting.new(code: :check_tara_url,
                             value: check_tara_url_value,
                             description: check_tara_url_description,
                             value_format: 'string')

check_tara_url.save

# Voog site default URL
voog_site_url_description = <<~TEXT.squish
  VOOG site from which to fetch localized footer elements. Defaults to https://www.internet.ee.
TEXT

voog_site_url_setting = Setting.new(code: :voog_site_url, value: 'https://www.internet.ee',
                                    description: voog_site_url_description,
                                    value_format: 'string')
voog_site_url_setting.save

# Voog site API token
voog_api_key_description = <<~TEXT.squish
  VOOG site API key. Required to fetch footer content.
TEXT

voog_api_key_setting = Setting.new(code: :voog_api_key, value: 'changeme',
                                   description: voog_api_key_description,
                                   value_format: 'string')
voog_api_key_setting.save

# Voog site API fetching enabled boolean
voog_site_fetching_enabled_description = <<~TEXT.squish
  Boolean whether to enable fetching & showing footer element from VOOG site. Defaults to false.
TEXT

voog_site_fetching_enabled_setting = Setting.new(code: :voog_site_fetching_enabled, value: 'false',
                                                 description: voog_site_fetching_enabled_description,
                                                 value_format: 'boolean')
voog_site_fetching_enabled_setting.save

# Daily reminder on paid but not registered domains flag
daily_reminder_description = <<~TEXT.squish
  Days remaining to the registration deadline that triggers daily reminder email until
  deadline is reached or domain is registered. This is in addition
  to domain_registration_reminder setting that send reminder just once. Default: 0
TEXT

remind_on_domain_registration_everyday = Setting.new(code: :domain_registration_daily_reminder,
                                                     value: '0',
                                                     description: daily_reminder_description,
                                                     value_format: 'integer')

remind_on_domain_registration_everyday.save

# Directo integration state boolean
directo_integration_enabled_description = <<~TEXT.squish
  Enables or disables Directo Integration. Allowed values true / false. Defaults to false.
TEXT

directo_integration_enabled_setting = Setting.new(code: :directo_integration_enabled, value: 'false',
                                                  description: directo_integration_enabled_description,
                                                  value_format: 'boolean')
directo_integration_enabled_setting.save

# Directo API URL
directo_api_url_description = <<~TEXT.squish
  API URL for Directo backend
TEXT

directo_api_url_setting = Setting.new(code: :directo_api_url, value: 'http://directo.test',
                                      description: directo_api_url_description,
                                      value_format: 'string')
directo_api_url_setting.save

# Directo Sales Agent
directo_sales_agent_description = <<~TEXT.squish
  Directo SalesAgent value. Retrieve it from Directo.
TEXT

directo_sales_agent_setting = Setting.new(code: :directo_sales_agent, value: 'AUCTION',
                                          description: directo_sales_agent_description,
                                          value_format: 'string')
directo_sales_agent_setting.save

# Directo default payment terms
directo_default_payment_terms_description = <<~TEXT.squish
  Default payment term for creating invoices for Directo. Defaults to net10
TEXT

directo_default_payment_terms_setting = Setting.new(code: :directo_default_payment_terms, value: 'R',
                                                    description: directo_default_payment_terms_description,
                                                    value_format: 'string')
directo_default_payment_terms_setting.save

# OpenAI model
openai_model_description = <<~TEXT.squish
  OpenAI API model
TEXT
openai_model_value = 'gpt-3.5-turbo'
openai_model_setting = Setting.new(code: :openai_model,
                                   value: openai_model_value,
                                   description: openai_model_description,
                                   value_format: 'string')
openai_model_setting.save

# OpenAI domain list evaluation prompt
openai_evaluation_prompt_description = <<~TEXT.squish
  Default OpenAI prompt for evaluating domain list
TEXT
openai_domains_evaluation_prompt_value = 'prompt'
openai_domains_evaluation_prompt_setting = Setting.new(code: :openai_domains_evaluation_prompt,
                                                       value: openai_domains_evaluation_prompt_value,
                                                       description: openai_evaluation_prompt_description,
                                                       value_format: 'string')
openai_domains_evaluation_prompt_setting.save

# Estonian VAT rate
estonian_vat_rate_description = <<~TEXT.squish
  Default Estonian vat rate. Should be in decimal format like this: 0.2
TEXT

estonian_vat_rate_setting = Setting.new(code: :estonian_vat_rate,
                                                       value: '0.2',
                                                       description: estonian_vat_rate_description,
                                                       value_format: 'decimal')
estonian_vat_rate_setting.save!

# Default organization phone
default_organization_phone_description = <<~TEXT.squish
  Default organization phone
TEXT
default_organization_phone_value = '+372 727 1000'
default_organization_phone_setting = Setting.new(code: :organization_phone,
                                                 value: default_organization_phone_value,
                                                 description: default_organization_phone_description,
                                                 value_format: 'string')
default_organization_phone_setting.save

# Default organization phone
contact_organization_email_description = <<~TEXT.squish
  Default organization email
TEXT
contact_organization_email_value = 'info@internet.ee'
contact_organization_email_setting = Setting.new(code: :contact_organization_email,
                                                 value: contact_organization_email_value,
                                                 description: contact_organization_email_description,
                                                 value_format: 'string')
contact_organization_email_setting.save
