module SettingsHelper
  def filled_json_array?(text)
    data = JSON.parse(text)
    return false unless data.is_a? Array
    return false if data.empty?

    true
  rescue JSON::ParserError
    false
  end
end