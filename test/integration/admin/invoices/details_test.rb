require 'test_helper'

class AdminInvoiceDetailsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:administrator)
    @invoice = invoices(:payable)
  end

  def test_downloads_invoice
    get download_admin_invoice_path(@invoice)

    assert_response :ok
    assert_equal 'application/pdf', response.headers['content-type']
    assert_equal %(attachment; filename="#{@invoice.filename}"; filename*=UTF-8''#{@invoice.filename}), response.headers['content-disposition']
    assert_not_empty response.body
  end
end
