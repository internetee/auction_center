module Admin
  class Invoices::TogglePartialPaymentsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    def setup
      @user = users(:administrator)
      sign_in @user

      @invoice = invoices(:payable)
    end

    test "should toggle partial payments" do
      assert_not @invoice.partial_payments

      patch admin_invoice_toggle_partial_payment_path(@invoice)
      assert_redirected_to admin_invoice_path(@invoice)
      follow_redirect!

      assert @invoice.reload.partial_payments?

      assert_select "turbo-stream[action='toast'][message='#{I18n.t('invoices.partial_payments_activated')}']"
    end
  end
end
