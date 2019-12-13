class ApplicationSettingFormat < ApplicationRecord
  store_accessor :settings
  validates :data_type, presence: true, uniqueness: true
  validate :in_json_format, :validate_value
  validates :settings, json_uniq: true

  scope :with_application_setting, lambda { |setting_code|
    where("(settings->'#{setting_code}') IS NOT NULL")
  }

  FORMAT_VALIDATIONS = {
    boolean: [:validate_boolean_format],
    integer: [:validate_integer_format],
    string: [:validate_string_format],
    hash: [:validate_hash_format],
    array: [:validate_array_format],
  }.with_indifferent_access.freeze

  def update_setting!(code:, value: nil, description: nil)
    return NoMethodError unless settings.keys.any? code

    settings[code]['value'] = value unless value.nil? || value == ''
    settings[code]['description'] = description unless description.nil? || description == ''
    save
  end

  def validate_value
    return unless in_json_format

    methods = FORMAT_VALIDATIONS[data_type]
    return unless methods

    methods.each do |method|
      send(method)
    end
  end

  def validate_boolean_format
    error = false
    settings.keys.each do |code|
      error = true unless [true, false].include? settings[code]['value']
    end
    errors.add(:settings, :invalid) if error == true
  end

  def validate_integer_format
    error = false
    settings.keys.each do |code|
      error = true unless settings[code]['value'].is_a? Integer
    end
    errors.add(:settings, :invalid) if error == true
  end

  def validate_string_format
    settings.keys.each do |code|
      settings[code]['value'].to_s
      errors.add(:settings, :invalid) unless settings[code]['value'].is_a? String
    end
  end

  def validate_hash_format
    error = false
    settings.keys.each do |code|
      error = true unless settings[code]['value'].is_a? Hash
    end
    errors.add(:settings, :invalid) if error == true
  end

  def validate_array_format
    error = false
    settings.keys.each do |code|
      error = true unless settings[code]['value'].is_a? Array
    end
    errors.add(:settings, :invalid) if error == true
  end

  def in_json_format
    errors.add(:settings, :not_a_json_array) unless settings.is_a?(Hash)
    return true if settings.is_a?(Hash)

    false
  end
end
