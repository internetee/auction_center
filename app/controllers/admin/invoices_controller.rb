# rubocop:disable Metrics
# require 'invoice_already_paid'

module Admin
  class InvoicesController < BaseController
    before_action :authorize_user
    before_action :create_invoice_if_needed, except: %i[toggle_partial_payments update_billing_profile]
    before_action :set_invoice, only: %i[show download update edit toggle_partial_payments update_billing_profile]
    before_action :authorize_for_update, only: %i[edit update update_billing_profile]

    # GET /admin/invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
    def show
      @payment_orders = @invoice.payment_orders
      @billing_profiles = @invoice.user&.billing_profiles || []
    end

    # GET /admin/invoices
    def index
      invoices = Invoice.accessible_by(current_ability)
                        .includes(:paid_with_payment_order)
                        .search(params)

      if invoices.is_a?(Array)
        @pagy, @invoices = pagy_array(invoices, items: params[:per_page] ||= 15)
      else
        @pagy, @invoices = pagy(invoices, items: params[:per_page] ||= 15)
      end

    end

    # GET /admin/invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/download
    def download
      pdf = PDFKit.new(render_to_string('common/pdf', layout: false))
      raw_pdf = pdf.to_pdf

      send_data(raw_pdf, filename: @invoice.filename)
    end

    # GET /admin/invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/edit
    def edit
      if @invoice.paid?
        respond_to do |format|
          format.html do
            redirect_to admin_invoice_path(@invoice), notice: t('invoices.already_paid')
          end
          format.json { render json: @invoice.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /admin/invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
    def update
      respond_to do |format|
        if update_predicate
          format.html do
            redirect_to admin_invoice_path(@invoice), notice: t('invoices.marked_as_paid')
          end
          format.json { render :show, status: :ok, location: @invoice }
        else
          format.html { redirect_to admin_invoice_path(@invoice), notice: t(:something_went_wrong) }
          format.json { render json: @invoice.errors, status: :unprocessable_entity }
        end
      end
    rescue Errors::InvoiceAlreadyPaid
      respond_to do |format|
        format.html { redirect_to admin_invoice_path(@invoice), notice: t('invoices.already_paid') }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end

    # POST /admin/invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/toggle_partial_payments
    def toggle_partial_payments
      respond_to do |format|
        if @invoice.toggle(:partial_payments).save
          format.html do
            action = @invoice.partial_payments? ? 'activated' : 'deactivated'
            redirect_to admin_invoice_path(@invoice), notice: t("invoices.partial_payments_#{action}")
          end
          format.json { render :show, status: :ok, location: @invoice }
        else
          format.html { redirect_to admin_invoice_path(@invoice), notice: t(:something_went_wrong) }
          format.json { render json: @invoice.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH /admin/invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/update_billing_profile
    def update_billing_profile
      respond_to do |format|
        if @invoice.update(billing_profile_id: params[:invoice][:billing_profile_id])
          format.html do
            redirect_to admin_invoice_path(@invoice), notice: t('invoices.billing_profile_updated')
          end
          format.json { render :show, status: :ok, location: @invoice }
        else
          format.html do
            redirect_to admin_invoice_path(@invoice), alert: @invoice.errors.full_messages.join(', ')
          end
          format.json { render json: @invoice.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_invoice
      @invoice = Invoice.includes(:invoice_items).find(params[:id])
    end

    def update_params
      update_params = params.require(:invoice).permit(:notes)
      merge_updated_by(update_params)
    end

    def update_predicate
      @invoice.assign_attributes(update_params)
      raise(Errors::InvoiceAlreadyPaid, @invoice.id) if @invoice.paid?

      @invoice.mark_as_paid_at(Time.zone.now)
    end

    def authorize_user
      authorize! :read, Invoice
    end

    def authorize_for_update
      authorize! :update, @invoice
    end

    def create_invoice_if_needed
      InvoiceCreationJob.perform_later if InvoiceCreationJob.needs_to_run?
    end
  end
end
# rubocop:enable Metrics/ClassLength
