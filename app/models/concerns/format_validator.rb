module Concerns
  module FormatValidator
    extend ActiveSupport::Concern

    included do
      validate :validate_value

      FORMAT_VALIDATIONS = {
        terms_and_conditions_link: [:validate_json_hash],
        violations_count_regulations_link: [:validate_json_hash],
      }.with_indifferent_access.freeze
    end

    def validate_value
      methods = FORMAT_VALIDATIONS[code]
      return unless methods

      methods.each do |method|
        send(method)
      end
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
  end
end
