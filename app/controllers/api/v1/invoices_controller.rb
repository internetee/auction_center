module Api
  module V1
    class InvoicesController < BaseController
      respond_to :json

      skip_before_action :verify_authenticity_token
      before_action :set_auction, only: [:pay_deposit]
      before_action :set_invoice, only: [:one_off_payment]

      # rubocop:disable Metrics/AbcSize
      def index
        @issued_invoices = invoices_list_by_status(Invoice.statuses[:issued])
        @paid_invoices = invoices_list_by_status(Invoice.statuses[:paid])
        @cancelled_payable_invoices = invoices_list_by_status(Invoice.statuses[:cancelled]).with_ban
        @cancelled_expired_invoices = invoices_list_by_status(Invoice.statuses[:cancelled]).without_ban
        @deposit_paid = current_user.domain_participate_auctions.includes(:auction).order(created_at: :desc)

        render json: {
          issued_invoices: @issued_invoices,
          paid_invoices: @paid_invoices,
          cancelled_payable_invoices: @cancelled_payable_invoices,
          cancelled_expired_invoices: @cancelled_expired_invoices,
          deposit_paid: @deposit_paid.map do |dpa|
            {
              id: dpa.id,
              created_at: dpa.created_at,
              status: dpa.status,
              invoice_number: dpa.invoice_number,
              domain_name: dpa.auction.domain_name,
              auction_id: dpa.auction_id
            }
          end
        }
      end

      def one_off_payment
        render json: { errors: 'Invoice not found' } and return unless @invoice

        response = EisBilling::OneoffService.call(invoice_number: @invoice.number.to_s,
                                                  customer_url: mobile_payments_deposit_callback_url,
                                                  amount: @invoice.amount)

        if response.result?
          render json: { oneoff_redirect_link: response.instance['oneoff_redirect_link'] }
        else
          render json: { errors: response.errors }
        end
      end

      def pay_deposit
        render json: { errors: 'Auction not found' } and return unless @auction

        description = "auction_deposit #{@auction.domain_name}, user_uuid #{current_user.uuid}, " \
          "user_email #{current_user.email}"
        response = EisBilling::PayDepositService.call(amount: @auction.deposit,
                                                      customer_url: mobile_payments_deposit_callback_url, description:)
        if response.result?
          render json: { oneoff_redirect_link: response.instance['oneoff_redirect_link'] }
        else
          render json: { errors: response.errors }
        end
      end

      private

      def set_invoice
        @invoice = Invoice.find_by(uuid: params[:id])
      end

      def set_auction
        @auction = Auction.find_by(uuid: params[:id])
      end

      def invoices_list_by_status(status)
        Invoice.accessible_by(current_ability)
               .where(user_id: current_user.id)
               .where(status:)
               .order(due_date: :desc)
      end
    end
  end
end
