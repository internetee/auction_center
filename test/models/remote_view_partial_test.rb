require 'test_helper'

class RemoteViewPartialTest < ActiveSupport::TestCase
  def setup
    super
  end

  def test_rendered_html_partial_is_sanitized
    processed_html = RemoteViewPartial.sanitized(name: 'xss', locale: 'en')
    assert_equal('<img>', processed_html)
  end

  def test_can_not_save_partial_with_existing_name_locale_combination
    partial = RemoteViewPartial.new(name: 'xss', locale: 'en', content: '<center>Random content</center>')
    assert partial.invalid?
  end
end
