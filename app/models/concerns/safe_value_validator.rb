class SafeValueValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true if value.blank?

    if %r{[^a-zA-Z\/\d\s\/\'\-]}.match?(value)
      record.errors.add(attribute, :invalid)
      return false
    end
    true
  end
end
