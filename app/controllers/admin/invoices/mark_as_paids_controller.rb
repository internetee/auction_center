module Admin
  class Invoices::MarkAsPaidsController < BaseController
    rescue_from Errors::InvoiceAlreadyPaid, with: :invoice_already_paid

    before_action :set_invoice
    
    # order is important! before set invoice, otherwise @invoice wont be set
    include ::Invoices::UpdateAuthorizable

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

    def invoice_params
      params.require(:invoice).permit(:notes, :paid_at)
    end
  end
end