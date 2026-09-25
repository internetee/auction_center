require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  setup do
    Spy.on_instance_method(EisBilling::BaseController, :authorized).and_return(true)
    @invoice = invoices(:payable)

    @everypay_link = {
      everypay_link: 'http://link.test'
    }
  end

  def test_should_send_data_to_billing_directo
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/invoice_generator')
      .to_return(status: 200, body: @everypay_link.to_json, headers: {})

    response = EisBilling::Invoice.call(invoice: @invoice)
    assert_equal response.instance['everypay_link'], 'http://link.test'
  end

  def test_should_send_due_date_locale_and_return_url_for_montonio_link
    @invoice.user.update_column(:locale, 'et')

    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/invoice_generator')
      .to_return(status: 200, body: @everypay_link.to_json, headers: {})

    EisBilling::Invoice.call(invoice: @invoice)

    assert_requested(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/invoice_generator') { |req|
      body = JSON.parse(req.body)

      assert_equal @invoice.due_date.to_date.iso8601, body['due_date']
      assert_equal 'et', body['locale']
      assert_equal 'https://auction.example.test/montonio_callback', body['return_url']
      true
    }
  end

  def test_should_fall_back_to_english_locale_when_user_locale_is_unsupported
    @invoice.user.update_column(:locale, 'zz')

    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/invoice_generator')
      .to_return(status: 200, body: @everypay_link.to_json, headers: {})

    EisBilling::Invoice.call(invoice: @invoice)

    assert_requested(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/invoice_generator') { |req|
      assert_equal 'en', JSON.parse(req.body)['locale']
      true
    }
  end
end
