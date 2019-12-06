module Concerns
  module FormatValidator
    extend ActiveSupport::Concern

    included do
      validate :validate_value

      FORMAT_VALIDATIONS = {
        boolean: [:validate_boolean_format],
        integer: [:validate_integer_format],
        string: [:validate_string_format],
        hash: [:validate_hash_format],
        array: [:validate_array_format],
      }.with_indifferent_access.freeze
    end

    def validate_value
      methods = FORMAT_VALIDATIONS[data_type]
      return unless methods

      methods.each do |method|
        send(method)
      end
    end

    def validate_boolean_format
      error = false
      settings.each do |setting|
        error = true unless [true, false].include? setting['value']
      end
      errors.add(:settings, :invalid) if error == true
    end

    def validate_integer_format
      error = false
      settings.each do |setting|
        error = true unless setting['value'].is_a? Integer
      end
      errors.add(:settings, :invalid) if error == true
    end

    def validate_string_format
      error = false
      settings.each do |setting|
        error = true unless setting['value'].is_a? String
      end
      errors.add(:settings, :invalid) if error == true
    end

    def validate_hash_format
      error = false
      settings.each do |setting|
        error = true unless parsable_json_hash?(setting['value'])
      end
      errors.add(:settings, :invalid) if error == true
    end

    def validate_array_format
      error = false
      settings.each do |setting|
        error = true unless parsable_json_array?(setting['value'])
      end
      errors.add(:settings, :invalid) if error == true
    end

    def validate_json_hash
      return if parsable_json_hash?(value)

      errors.add(:value, :invalid)
    end

    def parsable_json_hash?(value)
      JSON.parse(value).is_a?(Hash)
    rescue JSON::ParserError
      errors.add(:value, :not_a_json_hash)
    end

    def parsable_json_array?(value)
      JSON.parse(value).is_a?(Array)
    rescue JSON::ParserError
      errors.add(:value, :not_a_json_array)
      false
    end
  end
end
