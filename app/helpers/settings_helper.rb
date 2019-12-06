module SettingsHelper
  def formatted_setting_value(setting)
    return setting unless filled_json_array?(setting)

    elements = ''
    values = JSON.parse(setting)
    values.each do |value|
      elements << content_tag(:a, value, class: 'ui label')
    end
    simple_format(elements)
  end

  def filled_json_array?(text)
    return false unless text.is_a? String

    JSON.parse(text).is_a?(Array) && JSON.parse(text).any?
  rescue JSON::ParserError
    false
  end
end
