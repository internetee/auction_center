module SettingsHelper
  def filled_json_array?(text)
    JSON.parse(text).is_a?(Array) && JSON.parse(text).first.present?
  rescue JSON::ParserError
    false
  rescue NoMethodError
    false
  end
end