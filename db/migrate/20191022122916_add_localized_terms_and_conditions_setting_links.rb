class AddLocalizedTermsAndConditionsSettingLinks < ActiveRecord::Migration[5.2]

  LOCALIZED_URLS = {
    en: 'https://www.internet.ee/domains/auction-environment-user-agreement',
    et: 'https://www.internet.ee/domeenid/domeenide-oksjonikeskkonna-kasutajatingimused',
    ru: 'https://www.internet.ee/domeny/dogovor-pol-zovatelya-aukcionnoj-sredy'
  }.freeze

  def up
    LOCALIZED_URLS.each do |key, value|
      terms_and_conditions_description = <<~TEXT.squish
      Link to terms and conditions document in #{key} locale. Can be relative ('/public/terms_and_conditions.pdf')
      or absolute ('https://example.com/terms_and_conditions.pdf'). Relative link must start with a
      forward slash. Default is: https://example.com
      TEXT

      terms_and_conditions_setting = Setting.new(code: "terms_and_conditions_link_#{key}".to_sym,
                                                 value: value,
                                                 description: terms_and_conditions_description)

      terms_and_conditions_setting.save
    end
  end

  def down
    LOCALIZED_URLS.each do |key, _value|
      Setting.where(code: :"terms_and_conditions_link_#{key}".to_sym).delete_all
    end

  end
end
