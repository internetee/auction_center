class ApplicationSetting
  include ActiveModel::Model
  include Concerns::ApplicationSettingFormatValidator
  attr_accessor :code, :description, :value, :created_at, :updated_at, :updated_by, :data_type

  validates :code, presence: true
  validates :description, :created_at, presence: true
  validates :value, exclusion: { in: [nil, ''] } # allow false boolean
  validate :correct_value_type

  def unique_setting_code?
    return true unless ApplicationSettingFormat.with_application_setting(code).any?

    errors.add(:code, :taken)
    false
  end

  def correct_value_type
    return true if data_type == 'integer' && value !~ /\D/
    return true if (%w[hash array].include? data_type) && ([Hash, Array].include? value.class)
    return true if data_type == 'boolean' && [FalseClass, TrueClass].include?(value.class)
    return true if data_type == 'string' && (value.is_a? String)

    errors.add(:value, :invalid)
    false
  end

  def create
    self.created_at = Time.zone.now
    return false unless valid?
    return false if data_type.blank?

    return false unless unique_setting_code?

    setting_format = ApplicationSettingFormat.find_by(data_type: data_type)
    setting_format.settings[code] = as_json(only: %w[description value created_at updated_at
                                                     updated_by])
    setting_format.save!
  end

  def update(params)
    setting_format = ApplicationSettingFormat.with_application_setting(code).first
    setting = ApplicationSetting.find_by(code: code).update_values(params: params)

    if setting.valid?
      setting_format.settings[code] = setting.as_json(only: %w[description value created_at
                                                               updated_at updated_by])
      return true if setting_format.save
    end
    errors.add(:value, :invalid)
    false
  end

  def update_values(params:)
    self.description = params[:description] if params[:description].present?
    self.updated_at = Time.zone.now
    self.updated_by = params[:updated_by] if params[:updated_by].present?
    self.value = params[:value] if params[:value].present?
    self.value = value_in_format if correct_value_type
    self
  end

  def value_in_format(value: self.value, data_type: self.data_type)
    return value.to_i if data_type == 'integer'
    return value == 'true' if data_type == 'boolean'
    return value.as_json if %w[hash array].include? data_type

    value
  end

  def self.all
    hash = []
    ApplicationSettingFormat.all.find_each do |stng_format|
      stng_format.settings.keys.each do |code|
        setting = ApplicationSetting.new(stng_format.settings[code].merge(code: code))
        setting.value = setting.value_in_format(data_type: stng_format.data_type)
        hash << setting
      end
    end
    hash
  end

  def self.find_by(code:)
    app_setting_format = ApplicationSettingFormat.with_application_setting(code).first
    return if app_setting_format.blank?

    setting = ApplicationSetting.new(app_setting_format.settings[code])
    setting.data_type = app_setting_format.data_type
    setting.code = code

    setting
  end

  ApplicationSettingFormat.find_each do |inst|
    inst.settings.keys.each do |code|
      define_singleton_method(code) do
        a = ApplicationSettingFormat.with_application_setting(code).first
        case code
        when 'terms_and_conditions_link'
          return a.settings[code]['value'][I18n.locale.to_s]
        when 'violations_count_regulations_link'
          return a.settings[code]['value'][I18n.locale.to_s]
        when 'auction_duration'
          return :end_of_day if a.settings[code]['value'] == 'end_of_day'

          return a.settings[code]['value'].to_i
        when 'auctions_start_at'
          return false if a.settings[code]['value'] == 'false'

          return a.settings[code]['value'].to_i
        end

        return a.settings[code]['value'].as_json if %w[hash array].include? inst.data_type

        return a.settings[code]['value']
      end
    end
  end
end
