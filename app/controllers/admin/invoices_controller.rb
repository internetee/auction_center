# rubocop:disable Metrics
# require 'invoice_already_paid'

module Admin
  class InvoicesController < BaseController
    before_action :authorize_user
    before_action :create_invoice_if_needed
    before_action :set_invoice, only: %i[show download]

    # GET /admin/invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
    def show
      @payment_orders = @invoice.payment_orders
    end

    # GET /admin/invoices
    def index
      invoices = Invoice.accessible_by(current_ability)
                        .includes(:paid_with_payment_order)
                        .search(params)

      if invoices.is_a?(Array)
        @pagy, @invoices = pagy_array(invoices, items: params[:per_page] ||= 15)
      else
        @pagy, @invoices = pagy(invoices, items: params[:per_page] ||= 15)
      end
    end

    # GET /admin/invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/download
    def download
      pdf = PDFKit.new(render_to_string('common/pdf', layout: false))
      raw_pdf = pdf.to_pdf

      send_data(raw_pdf, filename: @invoice.filename)
    end

    private

    def set_invoice
      @invoice = Invoice.includes(:invoice_items).find(params[:id])
    end

    def authorize_user
      authorize! :read, Invoice
    end

    def create_invoice_if_needed
      InvoiceCreationJob.perform_later if InvoiceCreationJob.needs_to_run?
    end
  end
end
# rubocop:enable Metrics/ClassLength
