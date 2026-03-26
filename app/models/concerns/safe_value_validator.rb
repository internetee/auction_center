class SafeValueValidator < ActiveModel::EachValidator
  RIGHT_SINGLE_QUOTE = "\u2019"
  DISALLOWED_PATTERN = Regexp.new("[^a-zA-Z\\p{Latin}/\\d\\s/''" + RIGHT_SINGLE_QUOTE + "\\-.,]")

  def validate_each(record, attribute, value)
    return true if value.blank?

    if DISALLOWED_PATTERN.match?(value)
      record.errors.add(attribute, I18n.t('.value_is_not_safe'))
      return false
    end
    true
  end
end
