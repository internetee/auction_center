class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user

  def edit; end

  def update; end

  def show
    @invoice = Invoice.accessible_by(current_ability).find(params[:id])
  end

  private

  def authorize_user
    authorize! :read, Invoice
    authorize! :update, Invoice
  end
end
