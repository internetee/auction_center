module Admin
  class Invoices::MarkAsPaidsController < BaseController
    rescue_from Errors::InvoiceAlreadyPaid, with: :invoice_already_paid

    before_action :set_invoice
    before_action :authorize_user
    before_action :authorize_for_update

    def edit; end

    def update
      raise(Errors::InvoiceAlreadyPaid, @invoice.id) if @invoice.paid?

      @invoice.assign_attributes(invoice_params)
      @invoice.mark_as_paid_at(invoice_params[:paid_at])
      @invoice.save!

      flash[:notice] = t('invoices.marked_as_paid')
      redirect_to admin_invoice_path(@invoice), status: :see_other
    end

    private

    def set_invoice
      @invoice = Invoice.find(params[:invoice_id])
    end

    def invoice_already_paid
      flash[:alert] = t('invoices.already_paid')
      redirect_to admin_invoice_path(@invoice), status: :see_other
    end

    def authorize_user
      authorize! :read, Invoice
    end

    def authorize_for_update
      authorize! :update, @invoice
    end

    def invoice_params
      params.require(:invoice).permit(:notes, :paid_at)
    end
  end
end