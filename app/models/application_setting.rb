class ApplicationSetting
  include ActiveModel::Model
  include Concerns::SettingFormatValidator
  attr_accessor :code, :description, :value, :created_at, :updated_at

  validates :code, presence: true
  validates :description, :created_at, presence: true
  validates :value, exclusion: { in: [nil, ''] } # allow false boolean, but fail while nil / empty
  validate :unique_setting_code, on: :create

  def as_json(_options = {})
    {
      code: @code,
      description: @description,
      value: @value,
      created_at: @created_at,
      updated_at: @updated_at,
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

  def unique_setting_code
    return unless SettingDatum.with_application_setting(code).any?

    errors.add(:code, :invalid)
  end

  def test_update(params)
    app_setting_format = ApplicationSettingFormat.with_application_setting(code).first
    match_index = app_setting_format.settings.index(app_setting_format.settings.find { |s| s['code'] == code })
    old_elem = app_setting_format.settings[match_index]
    old_elem['description'] = description
    old_elem['value'] = params[:value]
    old_elem['value'] = params[:value].to_json if %w[hash array].include? app_setting_format.data_type
    old_elem['value'] = params[:value].to_i if app_setting_format.data_type == 'integer'
    old_elem['value'] = params[:value] == 'true' if app_setting_format.data_type == 'boolean'

    app_setting_format.settings[match_index] = old_elem
    app_setting_format.save
  end

  def self.all
    hash = []
    ApplicationSettingFormat.all.find_each do |stng_format|
      stng_format.settings.each do |stng|
        a = ApplicationSetting.new
        a.code = stng['code']
        a.description = stng['description']
        a.value = stng['value']
        a.value = JSON.parse(stng['value']) if %w[hash array].include? stng_format.data_type
        a.created_at = stng['created_at']
        a.updated_at = stng['updated_at']
        hash.append(a)
      end
    end
    hash
  end

  def self.find_by_code(code)
    app_setting_format = ApplicationSettingFormat.with_application_setting(code).first
    return if app_setting_format.blank?

    setting_obj = app_setting_format.settings.find { |setting| setting['code'] == code }

    ApplicationSetting.new(code: setting_obj['code'], description: setting_obj['description'],
                           value: setting_obj['value'], created_at: setting_obj['created_at'],
                           updated_at: setting_obj['updated_at'])
  end
end
