module Admin
  module Invoices
    class TogglePartialPaymentsController < BaseController
      before_action :set_invoice

      # order is important! before set invoice, otherwise @invoice wont be set
      include ::Invoices::UpdateAuthorizable

      def update
        if @invoice.toggle(:partial_payments).save

          action = @invoice.partial_payments? ? 'activated' : 'deactivated'
          redirect_to admin_invoice_path(@invoice), notice: t("invoices.partial_payments_#{action}"), status: :see_other
        else
          redirect_to admin_invoice_path(@invoice), alert: t(:something_went_wrong), status: :see_other
        end
      rescue StandardError => e
        Rails.logger.error "Error toggling partial payments: #{e.message}"
        puts "Error toggling partial payments: #{e.message}"
        redirect_to admin_invoice_path(@invoice), alert: t(:something_went_wrong), status: :see_other
      end

      def set_invoice
        @invoice = Invoice.find(params[:invoice_id])
      end
    end
  end
end
