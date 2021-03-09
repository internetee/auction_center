require 'test_helper'

class AutomaticBanTest < ActiveSupport::TestCase
  def setup
    super

    @time = DateTime.parse('2010-07-05 10:31 +0000')
    travel_to @time

    @user = users(:participant)
    @domain_name = 'example.test'
  end

  def teardown
    super

    clear_email_deliveries
    travel_back
  end

  def test_constant
    assert_equal(Setting.find_by(code: 'ban_length').retrieve, AutomaticBan::BAN_PERIOD_IN_MONTHS)
  end

  def test_automatic_ban_on_user_without_overdue_invoices_fails
    ban = AutomaticBan.new(invoice: Invoice.new, user: @user, domain_name: 'some-domain.test')

    assert_raises(Errors::NoCancelledInvoices) do
      ban.create
    end
  end

  def test_automatic_ban_creates_one_ban_per_invoice
    invoice, domain_name = create_bannable_offence(@user)
    AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name).create
    ban = AutomaticBan.new(invoice: Invoice.new, user: @user, domain_name: domain_name)

    assert_raises(Errors::NoCancelledInvoices) do
      ban.create
    end
  end

  def test_bans_are_based_on_number_of_cancelled_invoices
    invoice, domain_name, ban = create_ban_with_offence(@user)

    assert(ban.persisted?)
    assert_equal(invoice, ban.invoice)
    assert_equal(domain_name, ban.domain_name)
    assert_equal(@time >> ban_period, ban.valid_until)
  end

  def test_ban_for_second_invoice_is_also_long
    create_ban_with_offence(@user)
    invoice, domain_name, ban = create_ban_with_offence(@user)

    assert(ban.persisted?)
    assert_equal(invoice, ban.invoice)
    assert_equal(domain_name, ban.domain_name)
    assert_equal(@time >> ban_period, ban.valid_until)
  end

  def test_third_ban_is_long_and_have_domain_name
    create_ban_with_offence(@user)
    create_ban_with_offence(@user)

    invoice, domain_name, ban = create_ban_with_offence(@user)

    assert(ban.persisted?)
    assert_equal(invoice, ban.invoice)
    assert_equal(domain_name, ban.domain_name)
    assert_equal(@time >> ban_period, ban.valid_until)
  end

  def test_number_of_ban_offences_before_long_ban_is_configurable_in_settings
    setting = settings(:ban_number_of_strikes)
    setting.update!(value: '1')

    invoice, domain_name = create_bannable_offence(@user)
    ban = AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name).create

    assert(ban.persisted?)
    assert_equal(@time >> ban_period, ban.valid_until)
    assert(@user.completely_banned?)
  end

  def test_creating_a_ban_sends_an_email
    invoice, domain_name = create_bannable_offence(@user)
    clear_email_deliveries

    AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name).create

    assert_not(ActionMailer::Base.deliveries.empty?)
    last_email = ActionMailer::Base.deliveries.last

    assert_equal("Participation in #{domain_name} auction prohibited", last_email.subject)
    assert_equal(['user@auction.test'], last_email.to)
  end
end
