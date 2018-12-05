class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user

  def show
    @invoice = Invoice.find(params[:id])
  end

  private

  def authorize_user
    authorize! :manage, Invoice
  end
end
