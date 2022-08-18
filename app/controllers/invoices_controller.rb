class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user
  before_action :set_invoice, except: [:index, :pay_all_bills, :one_off]

  # GET /invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/edit
  def edit; end

  # PUT /invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def update
    respond_to do |format|
      if update_predicate
        format.html { redirect_to invoice_path(@invoice.uuid), notice: t(:updated) }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { redirect_to invoice_path(@invoice.uuid), notice: t(:something_went_wrong) }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def show; end

  # GET /invoices
  def index
    @issued_invoices = invoices_list_by_status(Invoice.statuses[:issued])
    @paid_invoices = invoices_list_by_status(Invoice.statuses[:paid])
    @cancelled_payable_invoices = invoices_list_by_status(Invoice.statuses[:cancelled]).with_ban
    @cancelled_expired_invoices = invoices_list_by_status(Invoice.statuses[:cancelled]).without_ban
  end

  # GET /invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/download
  def download
    pdf = PDFKit.new(render_to_string('common/pdf', layout: false))
    raw_pdf = pdf.to_pdf

    send_data(raw_pdf, filename: @invoice.filename)
  end

  def invoices_list_by_status(status)
    Invoice.accessible_by(current_ability)
           .where(user_id: current_user.id)
           .where(status: status)
           .order(due_date: :desc)
  end

  def pay_all_bills
    issued_invoices = invoices_list_by_status(Invoice.statuses[:issued])
    result = EisBilling::BulkInvoices.generate_link(issued_invoices)

    @everypay_link = JSON.parse(result.body, symbolize_names: true)[:everypay_link]

    respond_to do |format|
      format.json { render status: :ok, json: @everypay_link }
      format.html { redirect_to :back, :notice => 'Run was successfully created.' }
      format.js
    end
  end

  def oneoff
    body = EisBilling::OneoffPaymentSender.send_request(invoice: @invoice)
    parsed_response = JSON.parse(body)

    if parsed_response["error"].presence
      flash[:error] = parsed_response["error"]["message"]

      redirect_to invoice_path(uuid: @invoice.uuid) and return
    end

    payment_link = parsed_response["payment_link"]

    redirect_to payment_link
  end

  def update_predicate
    @invoice.issued? && @invoice.update(update_params)
  end

  def update_params
    update_params = params.require(:invoice).permit(:billing_profile_id)
    merge_updated_by(update_params)
  end

  def set_invoice
    @invoice = Invoice.accessible_by(current_ability).find_by!(uuid: params[:uuid])
  end

  def authorize_user
    authorize! :read, Invoice
    authorize! :update, Invoice
  end
end
