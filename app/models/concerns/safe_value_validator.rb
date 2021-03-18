class SafeValueValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true if value.blank?

    # Regexp for estonian unicode characters lower/upper-case
    unicode_chars = /\u00E4\u00C4\u00F5\u00D5\u00F6\u00D6\u00FC\u00DC\u0161\u0160\u017E\u017D/
    if %r{[^a-zA-Z#{unicode_chars.source}\/\d\s\/\'\’\-\.]}.match?(value)
      record.errors.add(attribute, I18n.t('.value_is_not_safe'))
      return false
    end
    true
  end
end
