# rubocop:disable Metrics
module Admin
  class PaidDeposit::DepositStatusesController < BaseController
    def update
      @deposit = DomainParticipateAuction.find(params[:id])

      deposits = DomainParticipateAuction.includes(:user).includes(:auction).search(params)
      @pagy, @deposits = pagy(deposits, items: params[:per_page] ||= 15)

      if @deposit.update(status: params[:status])
        res = @deposit.send_deposit_status_to_billing_system

        if res.result?
          redirect_to admin_paid_deposits_path, status: :see_other,
                                                flash: { notice: 'Invoice status updated successfully' }
        else
          flash[:alert] = "Deposit status is updated in auction side, but got error from billing side: #{res.errors}"
          redirect_to admin_paid_deposits_path, status: :see_other
        end
      else
        flash[:alert] = @deposit.errors.full_messages.join(', ')
        redirect_to admin_paid_deposits_path, status: :see_other
      end
    end
  end
end
