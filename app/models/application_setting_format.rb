class ApplicationSettingFormat < ApplicationRecord
  include Concerns::FormatValidator
  validates :data_type, presence: true, uniqueness: true

  scope :with_application_setting, lambda { |setting_code|
    where('? <@ ANY (settings)', { code: setting_code }.to_json)
  }

  ApplicationSettingFormat.find_each do |inst|
    inst.settings.each do |setting|
      define_singleton_method(setting['code']) do
        return JSON.parse(setting['value']) if %w[hash array].include? inst.data_type

        return setting['value']
      end
    end
  end
end
