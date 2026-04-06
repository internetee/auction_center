require 'test_helper'

class AdminInvoicesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = users(:administrator)
    @participant = users(:participant)
    @invoice = invoices(:payable)
  end

  def with_invoice_creation_disabled
    InvoiceCreationJob.stub(:needs_to_run?, false) do
      yield
    end
  end

  def stub_invoice_lookup(invoice)
    relation = Object.new
    relation.define_singleton_method(:find) { |_id| invoice }
    Invoice.stub(:includes, relation) do
      yield
    end
  end

  def test_index_renders_for_admin
    sign_in @admin

    with_invoice_creation_disabled do
      get admin_invoices_path
    end

    assert_response :ok
    assert_includes response.body, @invoice.number.to_s
  end

  def test_index_enqueues_invoice_creation_job_when_needed
    sign_in @admin

    InvoiceCreationJob.stub(:needs_to_run?, true) do
      InvoiceCreationJob.stub(:perform_later, true) do
        get admin_invoices_path
      end
    end

    assert_response :ok
  end

  def test_show_renders_for_admin
    sign_in @admin

    with_invoice_creation_disabled do
      get admin_invoice_path(@invoice.id)
    end

    assert_response :ok
    assert_includes response.body, @invoice.number.to_s
  end

  def test_edit_redirects_when_invoice_is_already_paid
    sign_in @admin
    @invoice.update_columns(status: 'paid', paid_at: Time.current)

    with_invoice_creation_disabled do
      get edit_admin_invoice_path(@invoice.id)
    end

    assert_redirected_to admin_invoice_path(@invoice)
  end

  def test_toggle_partial_payments_redirects_for_admin
    sign_in @admin

    service_result = Struct.new(:result?).new(true)
    EisBilling::UpdateInvoiceDataService.stub(:call, service_result) do
      post toggle_partial_payments_admin_invoice_path(@invoice.id)
    end

    assert_redirected_to admin_invoice_path(@invoice)
  end

  def test_index_returns_not_found_for_non_admin
    sign_in @participant

    with_invoice_creation_disabled do
      get admin_invoices_path
    end

    assert_response :not_found
  end
end
