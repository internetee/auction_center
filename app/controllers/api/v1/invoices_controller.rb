module Api
  module V1
    class InvoicesController < ApplicationController
      before_action :authenticate_user!
      respond_to :json

      skip_before_action :verify_authenticity_token

      # rubocop:disable Metrics/AbcSize
      def index
        @issued_invoices = invoices_list_by_status(Invoice.statuses[:issued])
        @paid_invoices = invoices_list_by_status(Invoice.statuses[:paid])
        @cancelled_payable_invoices = invoices_list_by_status(Invoice.statuses[:cancelled]).with_ban
        @cancelled_expired_invoices = invoices_list_by_status(Invoice.statuses[:cancelled]).without_ban
        @deposit_paid = current_user.domain_participate_auctions.order(created_at: :desc)

        render json: { issued_invoices: @issued_invoices, paid_invoices: @paid_invoices,
                       cancelled_payable_invoices: @cancelled_payable_invoices, cancelled_expired_invoices: @cancelled_expired_invoices, deposit_paid: @deposit_paid }
      end

      private

      def invoices_list_by_status(status)
        Invoice.accessible_by(current_ability)
               .where(user_id: current_user.id)
               .where(status: status)
               .order(due_date: :desc)
      end
    end
  end
end
