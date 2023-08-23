class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user
  before_action :set_invoice, except: %i[index pay_all_bills oneoff pay_deposit]

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

  # rubocop:disable Metrics/AbcSize
  def index
    @issued_invoices = invoices_list_by_status(Invoice.statuses[:issued])
    @cancelled_payable_invoices = invoices_list_by_status(Invoice.statuses[:cancelled]).with_ban
    @cancelled_expired_invoices = invoices_list_by_status(Invoice.statuses[:cancelled]).without_ban

    @unpaid_invoices_count = @issued_invoices.count + @cancelled_payable_invoices.count + @cancelled_expired_invoices.count

    @paid_invoices = invoices_list_by_status(Invoice.statuses[:paid])
    @deposit_paid = current_user.domain_participate_auctions.order(created_at: :desc)

    return unless params[:state] == 'payment'

    flash[:notice] = I18n.t('invoices.index.payment_success')
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
    response = EisBilling::BulkInvoicesService.call(invoices: issued_invoices,
                                                    customer_url: linkpay_callback_url)

    if response.result?
      redirect_to response.instance['oneoff_redirect_link'], allow_other_host: true
    else
      flash.alert = response.errors
      redirect_to invoices_path and return
    end
  end

  def pay_deposit
    auction = Auction.find_by(uuid: params[:uuid])
    authorize! :pay_deposit, auction
    description = "auction_deposit #{auction.domain_name}, user_uuid #{current_user.uuid}, " \
      "user_email #{current_user.email}"
    response = EisBilling::PayDepositService.call(amount: auction.deposit,
                                                  customer_url: deposit_callback_url,
                                                  description: description)

      puts '------'
      puts response.inspect
      puts response.instance['oneoff_redirect_link']
      puts response.result?
      puts '------'

    if response.result?
      redirect_to response.instance['oneoff_redirect_link'], allow_other_host: true, format: :html
    else
      flash.alert = response.errors['message']
      redirect_to invoices_path
    end
  end

  def oneoff
    invoice = Invoice.accessible_by(current_ability).find_by!(uuid: params[:uuid])
    response = EisBilling::OneoffService.call(invoice_number: invoice.number.to_s,
                                              customer_url: linkpay_callback_url)
    if response.result?
      redirect_to response.instance['oneoff_redirect_link'], allow_other_host: true, format: :html
    else
      flash.alert = response.errors['message']
      redirect_to invoices_path
    end
  end

  def send_e_invoice
    invoice = Invoice.accessible_by(current_ability).find_by!(uuid: params[:uuid])
    response = EisBilling::SendEInvoice.call(invoice: invoice, payable: !invoice.paid?)

    if response.result?
      redirect_to invoice_path(invoice.uuid), notice: t('.sent_to_omniva')
    else
      redirect_to invoice_path(invoice.uuid), alert: response.errors
    end
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
