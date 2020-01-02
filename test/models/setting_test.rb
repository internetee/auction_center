require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  def setup
    @subject = Setting.new
  end

  def test_required_fields
    assert_not(@subject.valid?)

    assert_equal(["can't be blank"], @subject.errors[:code])
    assert_equal(["can't be blank"], @subject.errors[:value])
    assert_equal(["can't be blank"], @subject.errors[:description])

    @subject.code = 'some_setting'
    @subject.value = 'true'
    @subject.description = 'Some unused setting'

    assert(@subject.valid?)
  end

  def test_code_must_be_unique
    @subject.code = 'some_setting'
    @subject.value = 'true'
    @subject.description = 'Some unused setting'

    @subject.save

    new_subject = @subject.dup

    assert_not(new_subject.valid?)
    assert_equal(['has already been taken'], new_subject.errors[:code])
  end

  def test_terms_and_conditions_parsing_and_multilocale
    Setting.find_by(code: :terms_and_conditions_link).update!(value: "{\"en\":\"https://example.com\", \"et\":\"https://example.et\"}")
    assert_equal('https://example.com', Setting.find_by(code: 'terms_and_conditions_link').retrieve)
  end

  def test_multilocale_violations_count_regulations_link
    Setting.find_by(code: :violations_count_regulations_link).update!(value: "{\"en\":\"https://regulations.test#some_anchor\"}")
    assert_equal('https://regulations.test#some_anchor', Setting.find_by(code: 'violations_count_regulations_link').retrieve)
  end

  def test_valid_format_for_wishlist_domain_extension_setting
    @setting = settings(:wishlist_supported_domain_extensions)
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
