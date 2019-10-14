require 'test_helper'
class SettingsHelperTest < ActionView::TestCase
  def setup
  end

  def test_array_has_valid_content
    valid_json = '["ee", "pri.ee", "com.ee", "med.ee", "fie.ee"]'
    assert filled_json_array?(valid_json)
  end

  def test_array_has_invalid_content
    unvalid_json = '["ee", "pri.ee", "com.ee", "med.ee", fie.ee"]'
    assert_not filled_json_array?(unvalid_json)
  end

  def test_array_has_empty_content
    empty_json_hash = '[]'
    assert_not filled_json_array?(empty_json_hash)
  end
end