require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  def setup
    @subject = Setting.new
  end

  def test_required_fields
    refute(@subject.valid?)

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

    refute(new_subject.valid?)
    assert_equal(['has already been taken'], new_subject.errors[:code])
  end
end
