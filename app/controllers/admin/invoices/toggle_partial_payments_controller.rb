module Admin
  class Invoices::TogglePartialPaymentsController < BaseController
    before_action :set_invoice
    before_action :authorize_user
    before_action :authorize_for_update

    def update
      if @invoice.toggle(:partial_payments).save
        action = @invoice.partial_payments? ? 'activated' : 'deactivated'
        redirect_to admin_invoice_path(@invoice), notice: t("invoices.partial_payments_#{action}"), status: :see_other
      else
        redirect_to admin_invoice_path(@invoice), alert: t(:something_went_wrong), status: :see_other
      end
    rescue StandardError => e
      Rails.logger.error "Error toggling partial payments: #{e.message}"
      redirect_to admin_invoice_path(@invoice), alert: t(:something_went_wrong), status: :see_other
    end

    def set_invoice 
      @invoice = Invoice.find(params[:invoice_id])
    end

    def authorize_user
      authorize! :read, Invoice
    end

    def authorize_for_update
      authorize! :update, @invoice
    end
  end
end