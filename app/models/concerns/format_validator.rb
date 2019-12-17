module Concerns
  module FormatValidator
    extend ActiveSupport::Concern

    included do
      validate :validate_value

      FORMAT_VALIDATIONS = {
        terms_and_conditions_link: [:validate_json_hash],
        violations_count_regulations_link: [:validate_json_hash],
        wishlist_supported_domain_extensions: [:validate_domain_extension_elements],
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

    def validate_domain_extension_elements
      return if valid_domain_extension_elements?

      errors.add(:value, :invalid)
    end

    # Allow 1-61 chars with Estonian diacritic signs as second-level domain (optional) and 1-61
    # characters as top level domain, which represents domain name extension when concatenated.
    def valid_domain_extension_elements?
      return false unless parsable_json_array?(value)

      domain_extension_regexp = /\A([a-z0-9\-\u00E4\u00F5\u00F6\u00FC\u0161\u017E]{1,61}\.)?
                                [a-z0-9]{1,61}\z/x
      JSON.parse(value).each do |item|
        return false unless item.match?(domain_extension_regexp)
      end
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
