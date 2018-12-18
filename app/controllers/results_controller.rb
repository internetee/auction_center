class ResultsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user
  before_action :create_invoice_if_needed

  # GET /results/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def show
    @result = Result.includes(:invoice)
                    .where(user_id: current_user.id)
                    .accessible_by(current_ability)
                    .find_by!(uuid: params[:uuid])
  end

  private

  def authorize_user
    authorize! :read, Result
  end

  def create_invoice_if_needed
    InvoiceCreationJob.perform_later if InvoiceCreationJob.needs_to_run?
  end
end
