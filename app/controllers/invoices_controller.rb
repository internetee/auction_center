class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user
  before_action :set_invoice, except: %i[index pay_all_bills pay_deposit]
  before_action :validate_amount, only: :oneoff

  # GET /invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/edit
  def edit; end

  # PUT /invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def update
    respond_to do |format|
      if update_predicate
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('invoice_information', 
              Modals::PayInvoice::InvoiceInformation::Component.new(invoice: @invoice)),
              turbo_stream.toast(t(:updated), position: "right", background: 'linear-gradient(to right, #11998e, #38ef7d)')
        ]
        end

        format.html { redirect_to invoices_path, notice: t(:updated) }
        format.json { render :show, status: :ok, location: @invoice }
      else
        error_str = if @invoice.errors.empty?
                      @invoice.payable? ? t(:something_went_wrong) : t('invoices.invoice_already_paid')
                    else  
                      @invoice.errors.full_messages.join('; ')
                    end

        format.turbo_stream do
          render turbo_stream: turbo_stream.toast(error_str, position: "right", background: 'linear-gradient(to right, #93291E, #ED213A)')
        end

        format.html { redirect_to invoices_path, status: :see_other, alert: error_str }
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

    # @unpaid_invoices_count = @issued_invoices.count + @cancelled_payable_invoices.count

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

  # TODO: Remove. It is deprecated
  def pay_all_bills
    payable_invoices = Invoice.accessible_by(current_ability)
                              .where(user_id: current_user.id).to_a.select(&:payable?)
    response = EisBilling::BulkInvoicesService.call(invoices: payable_invoices,
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
                                                  description:)

    if response.result?
      redirect_to response.instance['oneoff_redirect_link'], allow_other_host: true, format: :html
    else
      flash.alert = response.errors['message']
      redirect_to invoices_path
    end
  end

  def oneoff
    response = EisBilling::OneoffService.call(invoice_number: @invoice.number.to_s,
                                              customer_url: linkpay_callback_url,
                                              amount: params[:amount])


    if response.result?
      redirect_to response.instance['oneoff_redirect_link'], allow_other_host: true, format: :html
    else
      flash.alert = response.errors['message']
      redirect_to invoices_path
    end
  end

  def send_e_invoice
    response = EisBilling::SendEInvoice.call(invoice: @invoice, payable: !@invoice.paid?)

    if response.result?
      redirect_to invoice_path(@invoice.uuid), notice: t('.sent_to_omniva')
    else
      redirect_to invoice_path(@invoice.uuid), alert: response.errors
    end
  end

  private

  def invoices_list_by_status(status)
    Invoice.accessible_by(current_ability)
           .where(user_id: current_user.id)
           .where(status:)
           .order(due_date: :desc)
  end

  def update_predicate
    @invoice.payable? && @invoice.update(update_params)
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

  def validate_amount
    return if params[:amount].nil?

    alert = I18n.t('invoices.amount_must_be_positive') if params[:amount].to_f <= 0
    alert = I18n.t('invoices.amount_is_too_big') if params[:amount].to_f > @invoice.due_amount.to_f

    redirect_to invoice_path(@invoice.uuid), alert: alert if alert
  end
end
