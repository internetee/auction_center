module Admin
  class InvoicesController < BaseController
    before_action :authorize_user

    def show
      @invoice = Invoice.find(params[:id])
    end

    def index
      @invoices = Invoice.accessible_by(current_ability).order(due_date: :desc)
    end

    private

    def authorize_user
      authorize! :read, Invoice
    end
  end
end
