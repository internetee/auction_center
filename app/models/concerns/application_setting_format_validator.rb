module Concerns
  module ApplicationSettingFormatValidator
    extend ActiveSupport::Concern

    included do
      validate :validate_value

      FORMAT_VALIDATIONS = {
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

    def validate_domain_extension_elements
      return if valid_domain_extension_elements?

      errors.add(:value, :invalid)
    end

    # Allow 1-61 chars with Estonian diacritic signs as second-level domain (optional) and 1-61
    # characters as top level domain, which represents domain name extension when concatenated.
    def valid_domain_extension_elements?
      return false unless value.is_a? Array

      domain_extension_regexp = /\A([a-z0-9\-\u00E4\u00F5\u00F6\u00FC\u0161\u017E]{1,61}\.)?
                                [a-z0-9]{1,61}\z/x
      value.each do |item|
        return false unless item.match?(domain_extension_regexp)
      end
    end
  end
end
