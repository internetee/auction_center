class ResultsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user
  before_action :create_invoice_if_needed

  def show
    @result = Result.includes(:invoice)
                    .where(user_id: current_user.id)
                    .accessible_by(current_ability)
                    .find(params[:id])
  end

  private

  def authorize_user
    authorize! :read, Result
  end

  def create_invoice_if_needed
    InvoiceCreationJob.perform_later if InvoiceCreationJob.needs_to_run?
  end
end
