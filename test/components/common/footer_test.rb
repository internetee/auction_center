require "test_helper"

class FooterTest < ViewComponent::TestCase
  include ViewComponent::SystemTestHelpers

  def test_render_component
    render_inline(Common::Footer::Component.new)

    expected_copyrigth_text = I18n.t('common.footer.copyright')
    assert_selector '.c-footer__highlight__title div', text: expected_copyrigth_text
  
    expected_address = Setting.find_by(code: 'invoice_issuer_address').retrieve
    expected_reg_no = Setting.find_by(code: 'invoice_issuer_reg_no').retrieve
    expected_reg_no_text = I18n.t('reg_no') + ": " + expected_reg_no

    assert_selector '.c-footer__highlight__info', text: expected_address
    assert_selector '.c-footer__highlight__info', text: expected_reg_no_text

    email = Setting.find_by(code: 'contact_organization_email').retrieve
    phone = Setting.find_by(code: 'organization_phone').retrieve
  
    assert_selector '.c-footer__highlight__contact a[href^="mailto:"]', text: email
  
    assert_selector '.c-footer__highlight__contact a[href^="tel:"]', text: phone
  
    assert_selector '.c-footer__row__col.s-footer-col', text: I18n.t('common.footer.help_and_info')
    assert_selector '.c-footer__row__col.s-footer-col', text: I18n.t('common.footer.domain_regulation')
    assert_selector '.c-footer__row__col.s-footer-col', text: I18n.t('common.footer.faq')
    assert_selector '.c-footer__row__col.s-footer-col', text: I18n.t('common.footer.statistics')
    assert_selector '.c-footer__row__col.s-footer-col', text: I18n.t('common.footer.dispute_committee')
  
    assert_selector '.c-footer__row__col.s-footer-col a[href="https://internet.ee/domains/ee-domain-regulation"]'
    assert_selector '.c-footer__row__col.s-footer-col a[href="https://internet.ee/help-and-info/faq"]'
    assert_selector '.c-footer__row__col.s-footer-col a[href="https://internet.ee/help-and-info/statistics"]'
    assert_selector '.c-footer__row__col.s-footer-col a[href="https://internet.ee/domain-disputes/domain-disuptes-committee"]'
  
    assert_selector '.c-footer__row__col.s-footer-col', text: I18n.t('common.footer.registrars')
    assert_selector '.c-footer__row__col.s-footer-col', text: I18n.t('common.footer.list_of_accredited_registrars')
    assert_selector '.c-footer__row__col.s-footer-col', text: I18n.t('common.footer.terms_and_conditions_for_registrars')
    assert_selector '.c-footer__row__col.s-footer-col', text: I18n.t('common.footer.partner_programme')
  
    assert_selector '.c-footer__row__col.s-footer-col a[href="https://internet.ee/registrars/accredited-registrars"]'
    assert_selector '.c-footer__row__col.s-footer-col a[href="https://internet.ee/registrars/terms-and-conditions-for-becoming-a-registrar"]'
    assert_selector '.c-footer__row__col.s-footer-col a[href="https://internet.ee/registrars/become-a-ee-elite-partner"]'

    assert_selector '.c-footer__row__col.s-footer-col', text: I18n.t('common.footer.estonian_internet')
    assert_selector '.c-footer__row__col.s-footer-col', text: I18n.t('common.footer.contact_us')
    assert_selector '.c-footer__row__col.s-footer-col', text: I18n.t('common.footer.management')
    assert_selector '.c-footer__row__col.s-footer-col', text: I18n.t('common.footer.registrars_working_group')
  
    assert_selector '.c-footer__row__col.s-footer-col a[href="https://www.internet.ee/eif"]'
    assert_selector '.c-footer__row__col.s-footer-col a[href="https://www.internet.ee/eif/tasks-and-management"]'
    assert_selector '.c-footer__row__col.s-footer-col a[href="https://www.internet.ee/eif/registrars-workgroup"]'

    assert_selector '.c-footer__row__col.s-footer-col', text: I18n.t('common.footer.social_media')

    assert_selector 'a.c-socials__link[href="https://www.facebook.com/EE-748656818569233/"]'
    assert_selector 'a.c-socials__link[href="https://twitter.com/Eesti_Internet"]'
    # assert_selector 'a.c-socials__link[href=""]', text: ''
    assert_selector 'a.c-socials__link[href="https://www.youtube.com/channel/UC7nTB6zIwZYPFarlbKuEPRA"]'
    assert_selector 'a.c-socials__link[href="https://internet.ee/index.rss"]'
  end
end