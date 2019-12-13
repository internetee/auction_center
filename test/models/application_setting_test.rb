require 'test_helper'

class ApplicationSettingTest < ActiveSupport::TestCase
  def setup
    @subject = ApplicationSetting.new
  end

  def test_required_fields
    assert_not(@subject.valid?)

    assert_equal(["can't be blank"], @subject.errors[:code])
    assert_includes(@subject.errors[:value], "is invalid")
    assert_equal(["can't be blank"], @subject.errors[:description])

    @subject.code = 'some_setting'
    @subject.data_type = 'boolean'
    @subject.value = true
    @subject.description = 'Some unused setting'
    @subject.created_at = Time.zone.now

    assert(@subject.valid?)
  end

  def test_code_must_be_unique
    @subject.code = 'some_setting'
    @subject.value = 'true'
    @subject.description = 'Some unused setting'
    @subject.data_type = 'string'

    @subject.create

    new_subject = @subject.dup

    assert_not(new_subject.create)
    assert_equal(['has already been taken'], new_subject.errors[:code])
  end

  def test_class_methods_are_shorthand_for_values
    assert_equal('EUR', ApplicationSetting.auction_currency)
    assert_equal(500, ApplicationSetting.auction_minimum_offer)

    assert_equal('https://example.com', ApplicationSetting.terms_and_conditions_link)
    assert_equal('EE', ApplicationSetting.default_country)

    assert_equal(7, ApplicationSetting.payment_term)
    assert_equal(14, ApplicationSetting.registration_term)

    assert_equal(false, ApplicationSetting.require_phone_confirmation)

    assert_equal(24, ApplicationSetting.auction_duration)

    setting_format = application_setting_formats(:string)
    setting_format.update_setting!(code: 'auction_duration', value: 'end_of_day')

    assert_equal(:end_of_day, ApplicationSetting.auction_duration)

    assert_equal(0, ApplicationSetting.auctions_start_at)

    setting_format = application_setting_formats(:string)
    setting_format.update_setting!(code: 'auctions_start_at', value: 'false')

    assert_equal(false, ApplicationSetting.auctions_start_at)

    assert_equal(100, ApplicationSetting.ban_length)
    assert_equal(3, ApplicationSetting.ban_number_of_strikes)

    assert_equal(5, ApplicationSetting.domain_registration_reminder)
    assert_equal(1, ApplicationSetting.invoice_reminder_in_days)

    assert_equal('Eesti Interneti SA, VAT number EE101286464', ApplicationSetting.invoice_issuer)

    assert_equal(10, ApplicationSetting.wishlist_size)
  end

  def test_terms_and_conditions_parsing_and_multilocale
    setting_format = application_setting_formats(:hash)
    setting_format.update_setting!(code: 'terms_and_conditions_link', value: {"en": "https://example.com", "et": "https://example.et"})

    assert_equal('https://example.com', ApplicationSetting.terms_and_conditions_link)
  end

  def test_multilocale_violations_count_regulations_link
    setting_format = application_setting_formats(:hash)
    setting_format.update_setting!(code: 'violations_count_regulations_link', value: {"en": "https://regulations.test#some_anchor"})

    assert_equal('https://regulations.test#some_anchor', ApplicationSetting.violations_count_regulations_link)
  end

  def test_valid_format_for_wishlist_domain_extension_setting
    @setting = ApplicationSetting.find_by(code: 'wishlist_supported_domain_extensions')
    @setting.value = ["ee", "pri.ee"]
    assert @setting.valid?

    @setting.value = ["pri.ee"]
    assert @setting.valid?

    @setting.value = [".ee"]
    assert @setting.invalid?

    @setting.value = ["pri.ee.ee"]
    assert @setting.invalid?
  end
end
