module Admin
  class PaidDeposit::DepositStatusesController < BaseController
    def update
      @deposit = DomainParticipateAuction.find(params[:id])

      if @deposit.update(status: params[:status])
        redirect_to admin_paid_deposits_path, status: :see_other, flash: { notice: 'Invoice status updated successfully' }
      else
        render 'admin/paid_deposits/index', status: :unprocessable_entity
      end
    end
  end
end
