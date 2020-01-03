require 'test_helper'
class SettingsHelperTest < ActionView::TestCase
  def setup
  end

  def test_filled_setting_array_is_discovered
    valid_json = '["ee", "pri.ee", "com.ee", "med.ee", "fie.ee"]'
    assert filled_json_array?(valid_json)

    invalid_json = '["ee", "pri.ee", "com.ee", "med.ee", fie.ee"]'
    assert_not filled_json_array?(invalid_json)
  end

  def test_array_has_empty_content
    empty_json_hash = '[]'
    assert_not filled_json_array?(empty_json_hash)
  end

  def test_badges_are_returned_with_array
    value = '["ee"]'
    assert_equal formatted_setting_value(value), '<p><a class="ui label">ee</a></p>'
  end

  def test_generic_value_is_returned
    value = 'https://internet.ee'
    assert_equal formatted_setting_value(value), value
  end

  def test_generic_value_is_returned_with_empty_array
    value = '[]'
    assert_equal formatted_setting_value(value), value
  end
end
