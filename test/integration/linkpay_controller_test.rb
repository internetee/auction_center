require 'test_helper'

class LinkpayControllerTest < ActionDispatch::IntegrationTest
  def test_callback_sends_callback_and_redirects_to_invoices_payment_state
    EisBilling::SendCallbackService.stub(:call, lambda { |args|
      assert_equal 'PAYREF-1', args[:reference_number]
      true
    }) do
      get linkpay_callback_path, params: { payment_reference: 'PAYREF-1' }
    end

    assert_redirected_to invoices_path(state: 'payment')
  end

  def test_deposit_callback_sends_callback_and_redirects_to_auctions
    EisBilling::SendCallbackService.stub(:call, lambda { |args|
      assert_equal 'PAYREF-2', args[:reference_number]
      true
    }) do
      get deposit_callback_path, params: { payment_reference: 'PAYREF-2' }
    end

    assert_redirected_to auctions_path
  end
end
