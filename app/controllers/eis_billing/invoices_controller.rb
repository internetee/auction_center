module EisBilling
  class InvoicesController < EisBilling::BaseController
    before_action :load_invoice

    rescue_from InvoiceNotFound, with: :invoice_not_found

    def update
      state_machine

      if @invoice.errors.any?
        render json: { error: @invoice.errors }, status: :unprocessable_entity
      else
        render json: { message: 'Invoice data was successfully updated' },
               status: :ok
      end
    end

    private

    def load_invoice
      @invoice = ::Invoice.find_by(number: invoice_params[:invoice_number])
      return if @invoice.present?

      raise EisBilling::InvoiceNotFound
    end

    def invoice_params
      params.require(:invoice).permit(:invoice_number)
    end

    def invoice_not_found
      render json: {
        error: {
          message: "Invoice with #{invoice_params[:invoice_number]} number not found"
        }
      }, status: :not_found
    end

    def state_machine
      case params[:status]
      when 'unpaid'
        @invoice.update(status: 'issued', paid_at: nil)
      when 'paid'
        @invoice.payable? ? @invoice.mark_as_paid_at(Time.zone.now) : @invoice.errors.add(:base, 'Invoice is not payable')
      when 'cancelled'
        @invoice.update(status: 'cancelled', paid_at: nil)
      end
    end
  end
end
