require "test_helper"

class BadgetsTest < ViewComponent::TestCase
  def test_render_component
    render_inline(Common::Badgets::Component.new(status: 'paid'))
    assert page.has_css?('.c-badge.c-badge--green', text: I18n.t("invoices.paid_deposit.paid"))

    render_inline(Common::Badgets::Component.new(status: 'prepayment'))
    assert page.has_css?('.c-badge.c-badge--green.c-badge--circle', text: I18n.t("invoices.paid_deposit.prepayment"))

    render_inline(Common::Badgets::Component.new(status: 'returned'))
    assert page.has_css?('.c-badge.c-badge--blue', text: I18n.t("invoices.paid_deposit.returned"))

    render_inline(Common::Badgets::Component.new(status: 'pending'))
    assert page.has_css?('.c-badge.c-badge--yellow', text: I18n.t("invoices.paid_deposit.pending"))
  end
end
