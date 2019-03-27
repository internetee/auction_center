class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user
  before_action :set_invoice, except: :index

  # GET /invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/edit
  def edit; end

  # PUT /invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def update
    respond_to do |format|
      if update_predicate
        format.html { redirect_to invoice_path(@invoice.uuid), notice: t(:updated) }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def show; end

  # GET /invoices
  def index
    @issued_invoices = get_invoices_list_by_status(Invoice.statuses[:issued])
    @paid_invoices = get_invoices_list_by_status(Invoice.statuses[:paid])
  end

  # GET /invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/download
  def download
    pdf = PDFKit.new(render_to_string('pdf', layout: false))
    send_data pdf.to_pdf, filename: "foo.pdf"
  end

  private

  def get_invoices_list_by_status(status)
    Invoice.accessible_by(current_ability)
           .where(user_id: current_user.id)
           .where(status: status)
           .order(due_date: :desc)
  end

  def update_predicate
    @invoice.update(update_params)
  end

  def update_params
    params.require(:invoice).permit(:billing_profile_id)
  end

  def set_invoice
    @invoice = Invoice.accessible_by(current_ability).find_by!(uuid: params[:uuid])
  end

  def authorize_user
    authorize! :read, Invoice
    authorize! :update, Invoice
  end
end
