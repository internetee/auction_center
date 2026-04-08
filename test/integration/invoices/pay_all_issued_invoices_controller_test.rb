require 'test_helper'

class InvoicesPayAllIssuedInvoicesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:participant)
  end

  def post_create
    post pay_all_issued_invoices_path
  end

  def test_create_requires_authentication
    post_create
    assert_response :redirect
  end

  def test_create_redirects_to_oneoff_link_when_service_succeeds
    sign_in @user

    relation = Invoice.none
    response_double = Struct.new(:result?, :instance, :errors).new(true, { 'oneoff_redirect_link' => 'https://example.test/oneoff' }, {})

    Invoice.stub(:accessible_by, relation) do
      EisBilling::BulkInvoicesService.stub(:call, response_double) do
        post_create
      end
    end

    assert_redirected_to 'https://example.test/oneoff'
  end

  def test_create_sets_flash_and_redirects_to_invoices_when_service_fails
    sign_in @user

    relation = Invoice.none
    response_double = Struct.new(:result?, :instance, :errors).new(false, {}, 'bulk failed')

    Invoice.stub(:accessible_by, relation) do
      EisBilling::BulkInvoicesService.stub(:call, response_double) do
        post_create
      end
    end

    assert_redirected_to invoices_path
    assert_equal 'bulk failed', flash[:alert]
  end
end
