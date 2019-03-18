module Admin
  class InvoicesController < BaseController
    before_action :authorize_user
    before_action :create_invoice_if_needed

    def show
      @invoice = Invoice.find(params[:id])
    end

    def index
      @invoices = Invoice.accessible_by(current_ability).order(due_date: :desc).page(params[:page])
    end

    # POST /admin/invoices/search
    def search
      email = search_params[:email]

      @invoices = Invoice.joins(:user)
                         .where('users.email ILIKE ?', "%#{email}%")
                         .accessible_by(current_ability)
                         .page(1)
    end

    private

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
