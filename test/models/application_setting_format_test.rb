require 'test_helper'

class ApplicationSettingFormatTest < ActiveSupport::TestCase
  def setup
    @subject = ApplicationSettingFormat.new
  end

  def test_required_fields
    assert_not(@subject.valid?)

    assert_equal(["can't be blank"], @subject.errors[:data_type])

    @subject.data_type = 'some_setting'
    @subject.settings = {}

    assert(@subject.valid?)
  end

  def test_data_type_must_be_unique
    @subject.data_type = 'some_setting'
    @subject.settings = {}

    @subject.save

    @subject.reload

    new_subject = @subject.dup

    assert_not(new_subject.valid?)
    assert_equal(['has already been taken'], new_subject.errors[:data_type])
  end

  def test_setting_codes_must_be_unique
    setting_format = application_setting_formats(:boolean)
    setting_format.update_setting!(code: 'require_phone_confirmation', value: true)

    setting_format = application_setting_formats(:string)
    setting_format.settings["require_phone_confirmation"] = {"description": "whatever", "value": "whatever"}.as_json
    assert(setting_format.invalid?)
    assert_equal(setting_format.errors[:settings], ['require_phone_confirmation has already been taken'])
  end

  def test_only_accepts_json_hash_as_settings
    @subject = ApplicationSettingFormat.new
    @subject.data_type = "random"
    @subject.settings = {"random_boolean_value": {"description": "whatever", "value": true}}.as_json
    assert(@subject.valid?)

    @subject.settings = 'whatever'
    assert(@subject.invalid?)
  end

  def test_validates_integer_data_type
    setting_format = ApplicationSettingFormat.find_by(data_type: 'integer');
    integer_setting = {"description": "integer setting", "value": 1337}.as_json
    setting_format.settings["integer_setting"] = integer_setting
    assert(setting_format.valid?)

    integer_setting = {"description": "integer setting", "value": "1337"}.as_json
    setting_format.settings["integer_setting"] = integer_setting
    assert(setting_format.invalid?)
  end

  def test_validates_boolean_data_type
    setting_format = ApplicationSettingFormat.find_by(data_type: 'boolean');
    boolean_setting = {"description": "boolean setting", "value": false}.as_json
    setting_format.settings["boolean_setting"] = boolean_setting
    assert(setting_format.valid?)

    boolean_setting = {"description": "boolean setting", "value": "string"}.as_json
    setting_format.settings["boolean_setting"] = boolean_setting
    assert(setting_format.invalid?)
  end

  def test_validates_array_data_type
    setting_format = ApplicationSettingFormat.find_by(data_type: 'array');
    array_setting = {"description": "array_setting", "value": ["ee", "pri.ee", "com.ee", "med.ee", "fie.me"]}.as_json
    setting_format.settings["array_setting"] = array_setting
    assert(setting_format.valid?)

    array_setting = {"description": "boolean setting", "value": {"not": "not_an_array"} }.as_json
    setting_format.settings["array_setting"] = array_setting
    assert(setting_format.invalid?)
  end

  def test_validates_hash_data_type
    setting_format = ApplicationSettingFormat.find_by(data_type: 'hash');
    hash_setting = {"description": "array_setting", "value": {"et": "et", "en": "en"}}.as_json
    setting_format.settings["hash_setting"] = hash_setting
    assert(setting_format.valid?)

    hash_setting = {"description": "boolean setting", "value": ["not_a_hash"] }.as_json
    setting_format.settings["hash_setting"] = hash_setting
    assert(setting_format.invalid?)
  end

  def test_valid_format_for_wishlist_domain_extension_setting
    @setting = settings(:application_name)
    @setting.code = 'wishlist_supported_domain_extensions'
    @setting.value = '["ee", "pri.ee"]'
    assert @setting.valid?

    @setting.value = '["pri.ee"]'
    assert @setting.valid?

    @setting.value = '[".ee"]'
    assert @setting.invalid?

    @setting.value = '["pri.ee.ee"]'
    assert @setting.invalid?
  end
end
