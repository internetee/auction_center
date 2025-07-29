module Api
  module V1
    module Invoices
      class OneoffPaymentsController < BaseController
        respond_to :json
        skip_before_action :verify_authenticity_token
        before_action :set_invoice, only: [:create]

        def create
          response = EisBilling::OneoffService.call(invoice_number: @invoice.number.to_s,
                                                    customer_url: mobile_payments_deposit_callback_url,
                                                    amount: @invoice.total.to_f)

          if response.result?
            render json: { oneoff_redirect_link: response.instance['oneoff_redirect_link'] }
          else
            render json: { errors: response.errors }
          end
        end

        private

        def set_invoice
          @invoice = Invoice.find_by(uuid: params[:id])

          raise ActiveRecord::RecordNotFound unless @invoice
        end
      end
    end
  end
end
