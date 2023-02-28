require 'pagy/extras/overflow'
Pagy::I18n.load({ locale: 'en',
                  filepath: "#{Rails.root}/config/locales/pagy.en.yml" },
                { locale: 'et',
                  filepath: "#{Rails.root}/config/locales/pagy.et.yml" })
# default :empty_page (other options :last_page and :exception )
Pagy::DEFAULT[:overflow] = :last_page
Pagy::DEFAULT.freeze
