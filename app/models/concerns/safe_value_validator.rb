class SafeValueValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true if value.blank?

    unicode_chars = /\p{Latin}/
    invalid_chars_pattern = %r{[^a-zA-Z#{unicode_chars.source}/\d\s/'’\-.]}

    if invalid_chars_pattern.match?(value)
      invalid_chars = value.scan(invalid_chars_pattern).uniq

      record.errors.add(
        attribute,
        I18n.t('.value_is_not_safe_with_chars', invalid_chars: invalid_chars.join(', '))
      )
      return false
    end
    true
  end
end
