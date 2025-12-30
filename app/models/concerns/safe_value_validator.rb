class SafeValueValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true if value.blank?

    # Regexp for latin characters lower/upper-case
    unicode_chars = /\p{Latin}/
    if %r{[^a-zA-Z#{unicode_chars.source}\/\d\s\/\'\'\-\.\,]}.match?(value)
      record.errors.add(attribute, I18n.t('.value_is_not_safe'))
      return false
    end
    true
  end
end
