require 'pagy/extras/overflow'
require "pagy/extras/array"
require 'pagy/extras/i18n'

Pagy::I18n.load({ locale: 'en',
                  filepath: "#{Rails.root}/config/locales/pagy.en.yml" },
                { locale: 'et',
                  filepath: "#{Rails.root}/config/locales/pagy.et.yml" })
# default :empty_page (other options :last_page and :exception )
Pagy::DEFAULT[:overflow] = :last_page
Pagy::DEFAULT[:items] = 20
# Pagy::DEFAULT[:size] = [1,2,2,1]
# Comment out freeze to allow runtime item customization
# Pagy::DEFAULT.freeze
