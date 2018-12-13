class PaymentOrdersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[return callback]

  # POST /invoices/1/payment_orders
  def create
    @payment_order = PaymentOrder.new(create_params)

    respond_to do |format|
      if @payment_order.save
        format.html do
          redirect_to invoice_payment_order_path(@payment_order.invoice_id, @payment_order)
        end
        format.json { render :show, status: :created, location: @payment_order }
      else
        format.html { redirect_to invoice_path(@payment_order.invoice), notice: t(:error) }
        format.json { render json: @payment_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /invoices/1/payment_orders/1
  def show
    @payment_order = PaymentOrder.find_by!(id: params[:id], invoice_id: params[:invoice_id])
    @payment_order.return_url = return_invoice_payment_order_url(@payment_order.invoice,
                                                                 @payment_order)
    @payment_order.callback_url = callback_invoice_payment_order_url(@payment_order.invoice,
                                                                     @payment_order)
  end

  # ANY /invoices/1/payment_orders/1/return
  def return
    @payment_order = PaymentOrder.find_by!(id: params[:id], invoice_id: params[:invoice_id])
    @payment_order.update!(response: params.to_unsafe_h)

    respond_to do |format|
      if @payment_order.mark_invoice_as_paid
        format.html { redirect_to invoice_path(@payment_order.invoice), notice: t(:updated) }
        format.json { redirect_to invoice_path(@payment_order.invoice), notice: t(:updated) }
      else
        format.html { redirect_to invoice_path(@payment_order.invoice), notice: t(:error) }
        format.json { render json: @payment_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # ANY /invoices/1/payment_orders/1/callback
  def callback
    render status: :ok, json: { status: 'ok' }
  end

  private

  def create_params
    params.require(:payment_order).permit(:user_id, :invoice_id, :type)
  end
end
