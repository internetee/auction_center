class PaymentOrdersController < ApplicationController
  # POST /invoices/1/payment_orders
  def create
    @payment_order = PaymentOrder.new(create_params)

    respond_to do |format|
      if @payment_order.save
        format.html do
          redirect_to invoice_payment_order_path(@payment_order.invoice_id, @payment_order),
                      notice: t(:created)
        end
        format.json { render :show, status: :created, location: @payment_order }
      else
        format.html { redirect_to invoices_path(@payment_order.invoice), notice: t(:error)  }
        format.json { render json: @payment_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /invoices/1/payment_orders/1
  def show
    @payment_order = PaymentOrder.find_by!(id: params[:id], invoice_id: params[:invoice_id])
    @payment_order.return_url = return_invoice_payment_order_url(@payment_order)
    @payment_order.callback_url = callback_invoice_payment_order_url(@payment_order)
  end

  private

  def create_params
    params.require(:payment_order).permit(:user_id, :invoice_id, :type)
  end
end
