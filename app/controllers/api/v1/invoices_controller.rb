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
          issued_invoices: invoices_with_auction_name(@issued_invoices),
          paid_invoices: invoices_with_auction_name(@paid_invoices),
          cancelled_payable_invoices: invoices_with_auction_name(@cancelled_payable_invoices),
          cancelled_expired_invoices: invoices_with_auction_name(@cancelled_expired_invoices),
          deposit_paid: @deposit_paid.map do |dpa|
            {
              id: dpa.id,
              created_at: dpa.created_at,
              status: dpa.status,
              invoice_number: dpa.invoice_number,
              domain_name: dpa.auction.domain_name,
              auction_id: dpa.auction_id,
              auction_name: dpa.auction.domain_name
            }
          end
        }
      end

      private

      def invoices_list_by_status(status)
        Invoice.accessible_by(current_ability)
               .includes(result: :auction)
               .where(user_id: current_user.id)
               .where(status:)
               .order(due_date: :desc)
      end

      def invoices_with_auction_name(invoices)
        invoices.map do |invoice|
          invoice.as_json.merge(auction_name: invoice.result&.auction&.domain_name)
        end
      end
    end
  end
end
