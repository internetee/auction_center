class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user
  before_action :set_invoice

  # GET /invoices/1/edit
  def edit; end

  # PUT /invoices/1
  def update
    respond_to do |format|
      if @invoice.update(update_params)
        format.html { redirect_to invoice_path(@invoice), notice: t(:updated) }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /invoices/1
  def show; end

  private

  def update_params
    params.require(:invoice).permit(:billing_profile_id)
  end

  def set_invoice
    @invoice = Invoice.accessible_by(current_ability).find(params[:id])
  end

  def authorize_user
    authorize! :read, Invoice
    authorize! :update, Invoice
  end
end
