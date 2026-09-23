require 'test_helper'

class BanMailerTest < ActionMailer::TestCase
  def setup
    @user = users(:participant)
    @invoice = Invoice.new(payment_link: 'http://expired-linkpay.example')
    @ban = Ban.new(user: @user, invoice: @invoice, valid_until: 1.year.from_now)
    @domain_name = 'banned.test'
    @invoices_url = "#{ActionMailer::Base.default_url_options[:host]}/invoices"
  end

  def test_ban_mail_links_to_invoices_index_not_the_expired_payment_link
    email = BanMailer.ban_mail(@ban, 2, @domain_name)

    assert_includes(email.body.decoded, "href=#{@invoices_url}")
    assert_not_includes(email.body.decoded, @invoice.payment_link)
  end

  def test_final_ban_mail_links_to_invoices_index_not_the_expired_payment_link
    email = BanMailer.final_ban_mail(@ban, 3, @domain_name)

    assert_includes(email.body.decoded, "href=#{@invoices_url}")
    assert_not_includes(email.body.decoded, @invoice.payment_link)
  end
end
