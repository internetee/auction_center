class MakeDefaultCountryConfigurable < ActiveRecord::Migration[5.2]
  def up
    default_country_description = <<~TEXT.squish
      Alpha two code for default country, used for example in user and billing profile dropdowns.
      Example values: "EE", "GB", "US", "CA"
    TEXT

    default_country_setting = Setting.new(code: :default_country, value: 'EE',
                                   description: default_country_description)

    default_country_setting.save
  end

  def down
    Setting.where(code: :default_country_code).delete_all
  end
end
