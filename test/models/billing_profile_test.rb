require 'test_helper'

class BillingProfileTest < ActiveSupport::TestCase
  def setup
    super

    @user = users(:participant)
    @billing_profile = billing_profiles(:company)
    @orphaned_profile = billing_profiles(:orphaned)

    stub_request(:patch, 'http://eis_billing_system:3000/api/v1/invoice/update_invoice_data')
      .to_return(status: 200, body: @message.to_json, headers: {})
  end

  def test_required_fields
    billing_profile = BillingProfile.new

    assert_not(billing_profile.valid?)
    assert_equal(["can't be blank"], billing_profile.errors[:country_code])
    assert_equal(["can't be blank"], billing_profile.errors[:name])

    billing_profile.name = 'Private Person'
    billing_profile.street = 'Baker Street 221B'
    billing_profile.city = 'London'
    billing_profile.postal_code = 'NW1 6XE'
    billing_profile.country_code = 'GB'
    assert(billing_profile.valid?)
  end

  def test_does_not_accept_invalid_values
    billing_profile = BillingProfile.new
    billing_profile.name = '"><svg/onload=confirm(1)>'
    billing_profile.vat_code = "'-sleep(10)#"
    billing_profile.street = '{7*7}23x23${7*7}'
    billing_profile.city = '{{7*7}}'
    billing_profile.postal_code = '{{7*7}}'
    billing_profile.country_code = 'GB'
    assert_not(billing_profile.valid?)
  end

  def test_vat_codes_must_be_unique_per_user
    duplicate = @billing_profile.dup

    assert_not(duplicate.valid?)
    assert(duplicate.errors[:vat_code].include? 'has already been taken')

    private_person_profile = billing_profiles(:private_person)

    duplicate = private_person_profile.dup
    assert(duplicate.valid?)
  end

  def test_address
    expected_address = 'Baker Street 221B, NW1 6XE London, United Kingdom'

    assert_equal(expected_address, @billing_profile.address)
  end

  def test_user_name
    expected_username = 'Joe John Participant'

    assert_equal(expected_username, @billing_profile.user_name)
    assert_equal('Orphaned', @orphaned_profile.user_name)
  end

  def test_vat_rate_is_taken_from_country
    assert_equal(BigDecimal('0'), @billing_profile.vat_rate)

    @billing_profile.update(vat_code: nil, country_code: 'LU')
    assert_equal(BigDecimal('0.17'), @billing_profile.vat_rate)
  end

  def test_vat_rate_is_zero_if_vat_code_is_present
    @billing_profile.update(vat_code: nil, country_code: 'LU')
    assert_equal(BigDecimal('0.17'), @billing_profile.vat_rate)

    @billing_profile.update(vat_code: '12345')
    assert_equal(BigDecimal('0'), @billing_profile.vat_rate)
  end

  def test_estonian_customer_always_gets_vat_rate_applied
    assert_equal(BigDecimal('0'), @billing_profile.vat_rate)

    @billing_profile.update(country_code: 'EE')
    assert_equal(BigDecimal('0.20'), @billing_profile.vat_rate)
   end

  def test_customer_from_outside_european_union_has_vat_rate_0
    assert_equal(BigDecimal('0'), @billing_profile.vat_rate)

    @billing_profile.update(country_code: 'EE')
    assert_equal(BigDecimal('0.20'), @billing_profile.vat_rate)

    @billing_profile.update(country_code: 'US')
    assert_equal(BigDecimal('0'), @billing_profile.vat_rate)

    @billing_profile.update(country_code: 'BJ')
    assert_equal(BigDecimal('0'), @billing_profile.vat_rate)
  end

  def test_can_be_orphaned_by_a_user
    @user.destroy

    assert_nil(@billing_profile.user)
    assert_equal('Orphaned', @billing_profile.user_name)
  end

  def test_create_default_for_user_returns_if_already_exists
    assert_not(BillingProfile.create_default_for_user(@user.id))
  end

  def test_create_default_for_user_creates_a_billing_profile
    user_without_billing_profile = users(:second_place_participant)
    billing_profile = BillingProfile.create_default_for_user(user_without_billing_profile.id)

    assert_equal(billing_profile.country_code, user_without_billing_profile.country_code)
    assert_equal(billing_profile.name, user_without_billing_profile.display_name)
  end

  def invoice_with_billing_profile
    billing_profile_recipient = 'New Company Ltd'
    invoice = invoices(:payable)
    @billing_profile.update(name: billing_profile_recipient)
    invoice.reload

    assert_equal(billing_profile_recipient, invoice.recipient)
  end

  def test_scope_of_issues_invoices
    invoice_orph = invoices(:orphaned)
    invoice_orph.update(billing_profile_id: @billing_profile.id)
    invoice_orph.reload && @billing_profile.reload

    assert_equal @billing_profile.invoices.count, 2
    assert_equal @billing_profile.invoices.pluck(:status), ['issued', 'issued']
    
    assert_equal @billing_profile.issued_invoices.count, 2

    invoice_orph.mark_as_paid_at(Time.zone.now)
    invoice_orph.reload && @billing_profile.reload

    assert_equal @billing_profile.issued_invoices.count, 1
    assert_equal @billing_profile.issued_invoices.pluck(:status), ['issued']
  end

  def test_if_billing_profile_updated_all_related_issued_invoices_also_updated
    assert_equal @billing_profile.invoices.count, 1
    assert_equal @billing_profile.invoices.pluck(:status), ['issued']

    invoice = @billing_profile.invoices.first
    assert_equal invoice.billing_name, @billing_profile.name
    assert_equal invoice.billing_address, @billing_profile.address
    assert_equal invoice.billing_vat_code, @billing_profile.vat_code
    assert_equal invoice.billing_alpha_two_country_code, @billing_profile.alpha_two_country_code

    @billing_profile.name = 'New Company Ltd'
    @billing_profile.vat_code = '12345'
    @billing_profile.save(validate: false)

    @billing_profile.reload && invoice.reload

    invoice = @billing_profile.invoices.first
    assert_equal invoice.status, 'issued'
    assert_equal invoice.billing_name, 'New Company Ltd'
    assert_equal invoice.billing_address, @billing_profile.address
    assert_equal invoice.billing_vat_code, '12345'
    assert_equal invoice.billing_alpha_two_country_code, @billing_profile.alpha_two_country_code
  end

  def test_if_billing_profile_updated_it_not_effect_to_paid_or_canceled_invoices
    assert_equal @billing_profile.invoices.count, 1
    assert_equal @billing_profile.invoices.pluck(:status), ['issued']

    invoice = @billing_profile.invoices.first
    assert_equal invoice.billing_name, @billing_profile.name
    assert_equal invoice.billing_address, @billing_profile.address
    assert_equal invoice.billing_vat_code, @billing_profile.vat_code
    assert_equal invoice.billing_alpha_two_country_code, @billing_profile.alpha_two_country_code

    invoice.mark_as_paid_at(Time.zone.now)
    invoice.reload && @billing_profile.reload
    assert_equal invoice.status, 'paid'

    old_billing_profile_name = invoice.billing_name
    old_billing_vat_code = invoice.vat_code

    @billing_profile.update(name: 'New Company Ltd', vat_code: '12345')
    @billing_profile.reload && invoice.reload

    invoice = @billing_profile.invoices.first
    assert_equal invoice.status, 'paid'
    assert_not_equal invoice.billing_name, 'New Company Ltd'
    assert_equal invoice.billing_name, old_billing_profile_name
    assert_equal invoice.billing_address, @billing_profile.address
    assert_not_equal invoice.billing_vat_code, '12345'
    assert_equal invoice.billing_vat_code, old_billing_vat_code
    assert_equal invoice.billing_alpha_two_country_code, @billing_profile.alpha_two_country_code
  end
end
