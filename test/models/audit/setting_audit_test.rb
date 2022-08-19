# require 'test_helper'

# class SettingAuditTest < ActiveSupport::TestCase
#   def setup
#     super

#     travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
#     @setting = settings(:application_name)
#   end

#   def teardown
#     super

#     travel_back
#   end

#   def test_creating_a_setting_creates_a_history_record
#     setting = Setting.new(code: :some_setting, value: 'true', description: 'Some setting')
#     setting.save

#     assert(audit_record = Audit::Setting.find_by(object_id: setting.id, action: 'INSERT'))
#     assert_equal(setting.code, audit_record.new_value['code'])
#   end

#   def test_updating_a_setting_creates_a_history_record
#     @setting.update!(value: 'New Application Name')

#     assert_equal(1, Audit::Setting.where(object_id: @setting.id, action: 'UPDATE').count)
#     assert(audit_record = Audit::Setting.find_by(object_id: @setting.id, action: 'UPDATE'))
#     assert_equal(@setting.value, audit_record.new_value['value'])
#   end

#   def test_deleting_a_setting_creates_a_history_record
#     @setting.delete

#     assert_equal(1, Audit::Setting.where(object_id: @setting.id, action: 'DELETE').count)
#     assert(audit_record = Audit::Setting.find_by(object_id: @setting.id, action: 'DELETE'))
#     assert_equal({}, audit_record.new_value)
#   end

#   def test_diff_method_returns_only_fields_that_are_different
#     @setting.update!(description: 'New Description')
#     audit_record = Audit::Setting.find_by(object_id: @setting.id, action: 'UPDATE')

#     %w[updated_at description].each do |item|
#       assert(audit_record.diff.key?(item))
#     end

#     assert_equal(2, audit_record.diff.length)
#   end
# end
