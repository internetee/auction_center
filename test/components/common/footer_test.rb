require "test_helper"

class FooterTest < ViewComponent::TestCase
  include ViewComponent::SystemTestHelpers

  def setup
    VoogFooter.configure { |config| config.enabled = false }
  end

  def test_render_component
    I18n.with_locale(:en) do
      render_inline(Common::Footer::Component.new)

      assert_selector "h3.c-footer__highlight__title", text: I18n.t("common.footer.copyright")
      assert_selector ".c-footer__highlight__info", text: I18n.t("common.footer.address")
      assert_selector ".c-footer__highlight__info", text: I18n.t("common.footer.registration_code")

      email = Setting.find_by(code: "contact_organization_email").retrieve
      assert_selector '.c-footer__highlight__contact a[href^="mailto:"]', text: email

      assert_selector ".c-footer__highlight__contact", text: "727 1000"

      assert_column I18n.t("common.footer.help_and_info")
      assert_column I18n.t("common.footer.registrars")
      assert_column I18n.t("common.footer.estonian_internet")
      assert_column I18n.t("common.footer.social_media")

      assert_nav_link :domain_regulation
      assert_nav_link :faq
      assert_nav_link :statistics
      assert_nav_link :dispute_committee
      assert_nav_link :data_protection_policy
      assert_nav_link :content_management_principles
      assert_cookie_settings_link
      assert_nav_link :list_of_accredited_registrars
      assert_nav_link :partner_programme
      assert_nav_link :contact_us
      assert_nav_link :management
      assert_nav_link :documents
      assert_nav_link :newsletter
      assert_nav_link :information_security_principles

      terms_url = Setting.find_by(code: "terms_and_conditions_link").retrieve
      assert_selector(
        ".c-footer__row__col.s-footer-col a[href='#{terms_url}']",
        text: I18n.t("common.footer.labels.terms_and_conditions")
      )

      assert_social_link :facebook
      assert_social_link :twitter
      assert_social_link :youtube
      assert_social_link :linkedin
      assert_social_link :instagram
      assert_social_link :spotify
      assert_social_link :rss

      assert_selector "a.c-footer__sviiter[href='https://sviiter.ee']"
    end
  end

  private

  def assert_column(title)
    assert_selector ".c-footer__row__col.s-footer-col", text: title
  end

  def assert_nav_link(key)
    url = I18n.t("common.footer.links.#{key}")
    label = I18n.t("common.footer.labels.#{key}")
    assert_selector(".c-footer__row__col.s-footer-col a[href='#{url}']", text: label)
  end

  def assert_cookie_settings_link
    url = I18n.t("common.footer.links.cookie_settings")
    label = I18n.t("common.footer.labels.cookie_settings")
    assert_selector(
      ".c-footer__row__col.s-footer-col a[data-cc='c-settings'][href='#{url}']",
      text: label
    )
  end

  def assert_social_link(key)
    url = I18n.t("common.footer.links.#{key}")
    title = I18n.t("common.footer.social.#{key}")
    assert_selector(".c-socials a[href='#{url}'][title='#{title}']")
  end
end
