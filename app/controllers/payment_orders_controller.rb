class PaymentOrdersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[return callback]
  before_action :authorize_user, only: %i[create show]

  # POST /invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/payment_orders
  def create
    @payment_order = PaymentOrder.new(create_params)
    bind_invoices

    respond_to do |format|
      if create_predicate
        format.html { redirect_to payment_order_path(@payment_order.uuid) }
        format.json { render :show, status: :created, location: @payment_order }
      else
        format.html { redirect_to invoices_path(@payment_order.invoice), notice: t(:error) }
        format.json { render json: @payment_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /payment_orders/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def show
    @payment_order = PaymentOrder.find_by!(uuid: params[:uuid])
    @payment_order.return_url = return_payment_order_url(@payment_order.uuid)
    @payment_order.callback_url = callback_payment_order_url(@payment_order.uuid)
  end

  # POST /payment_orders/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/callback
  def callback
    render status: :ok, json: { status: 'ok' }
  end

  private

  def create_predicate
    @payment_order.save && @payment_order.reload
  end

  def bind_invoices
    @payment_order.invoices = Invoice.where(id: create_params[:invoice_ids].split(','))
  end

  def create_params
    params.require(:payment_order).permit(:user_id, :invoice_id, :invoice_ids, :type)
  end

  def authorize_user
    authorize! :read, PaymentOrder
    authorize! :create, PaymentOrder
  end
end
