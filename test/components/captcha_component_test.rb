require 'test_helper'

class CaptchaComponentTest < ViewComponent::TestCase
  def test_renders_checkbox_recaptcha_when_required
    component = Captcha::Component.new(captcha_required: true, show_checkbox_recaptcha: true, action: 'login')
    component.define_singleton_method(:recaptcha_tags) { |*, **| '<div class="recaptcha-tags"></div>'.html_safe }

    render_inline(component)

    assert_selector '.recaptcha-tags', count: 2
  end

  def test_renders_recaptcha_v3_when_required
    component = Captcha::Component.new(captcha_required: true, show_checkbox_recaptcha: false, action: 'login')
    component.define_singleton_method(:helpers) do
      Object.new.tap do |h|
        h.define_singleton_method(:recaptcha_v3) { |**| '<input name="g-recaptcha-response" />'.html_safe }
      end
    end

    render_inline(component)

    assert_selector 'input[name="g-recaptcha-response"]'
  end
end
