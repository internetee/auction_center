class JsonUniqValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    records = record.class.where.not(id: record.id).select(attribute)
    return if record.errors.any? # if val not in json format for example

    value.keys.each do |key|
      if records.any? { |rec| rec.public_send(attribute).key? key }
        record.errors.add(:settings, "#{key} has already been taken")
      end
    end
  end
end
