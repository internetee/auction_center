module Admin
  class Invoices::MarkAsPaidControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
      @user = users(:administrator)
      sign_in @user
      @invoice = invoices(:payable)
    end

    test 'should mark invoice as paid' do
      assert_not @invoice.paid?

      patch admin_invoice_mark_as_paid_path(@invoice), params: { invoice: { notes: 'test', paid_at: Time.zone.now - 1.day } }
      assert_redirected_to admin_invoice_path(@invoice)
      follow_redirect!
      @invoice.reload
      assert @invoice.reload.paid?
      assert_equal 'test', @invoice.notes
      assert_equal (Time.zone.now - 1.day).to_date, @invoice.paid_at.to_date

      assert_select "turbo-stream[action='toast'][message='#{I18n.t('invoices.marked_as_paid')}']"
    end

    test 'should not mark invoice as paid if already paid' do
      @invoice.mark_as_paid_at(Time.zone.now)
      assert @invoice.paid?

      patch admin_invoice_mark_as_paid_path(@invoice), params: { invoice: { notes: 'test', paid_at: Time.zone.now } }
      assert_redirected_to admin_invoice_path(@invoice)
      follow_redirect!

      assert_select "turbo-stream[action='toast'][message='#{I18n.t('invoices.already_paid')}']"
    end
  end
end
