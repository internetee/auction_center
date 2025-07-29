module Api
  module V1
    class InvoicesController < BaseController
      respond_to :json

      skip_before_action :verify_authenticity_token

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

      private

      def invoices_list_by_status(status)
        Invoice.accessible_by(current_ability)
               .where(user_id: current_user.id)
               .where(status:)
               .order(due_date: :desc)
      end
    end
  end
end
