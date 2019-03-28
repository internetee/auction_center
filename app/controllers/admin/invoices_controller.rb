module Admin
  class InvoicesController < BaseController
    before_action :authorize_user
    before_action :create_invoice_if_needed
    before_action :set_invoice, only: [:show, :download]

    # GET /admin/invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
    def show; end

    # GET /admin/invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
    def index
      @invoices = Invoice.accessible_by(current_ability)
                         .includes(:billing_profile, :user)
                         .order(due_date: :desc)
                         .page(params[:page])
    end

    # GET /admin/invoices/search
    def search
      email = search_params[:email]

      @invoices = Invoice.joins(:user)
                         .includes(:billing_profile)
                         .where('users.email ILIKE ?', "%#{email}%")
                         .accessible_by(current_ability)
                         .page(1)
    end

    # GET /admin/invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/download
    def download
      pdf = PDFKit.new(render_to_string('common/pdf', layout: false))
      raw_pdf = pdf.to_pdf

      send_data(raw_pdf, filename: @invoice.filename)
    end

    private

    def set_invoice
      @invoice = Invoice.includes(:billing_profile, :invoice_items, :user).find(params[:id])
    end

    def search_params
      params.permit(:email)
    end

    def authorize_user
      authorize! :read, Invoice
    end

    def create_invoice_if_needed
      InvoiceCreationJob.perform_later if InvoiceCreationJob.needs_to_run?
    end
  end
end
