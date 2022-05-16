# rubocop:disable Metrics/ClassLength
require 'invoice_already_paid'

module Admin
  class InvoicesController < BaseController
    include OrderableHelper

    before_action :authorize_user
    before_action :create_invoice_if_needed
    before_action :set_invoice, only: %i[show download update edit]
    before_action :authorize_for_update, only: %i[edit update]

    # GET /admin/invoices/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
    def show
      @payment_orders = @invoice.payment_orders
    end

    # GET /admin/invoices
    def index
      @invoices = Invoice.accessible_by(current_ability)
                         .includes(:paid_with_payment_order)
                         .order(orderable_array(default_order_params))
                         .page(params[:page])
    end

    # GET /admin/invoices/search
    def search
      @_params = search_params.compact_blank
      @origin = @_params[:order].present? ? @_params.dig(:order, :origin) : @_params
      @full_list = @_params[:full_list] || @_params.dig(:order, :origin, :full_list)
      @search_string = @_params[:search_string] || @_params.dig(:order, :origin, :search_string)
      @statuses_contains = @_params[:statuses_contains] || @_params.dig(:order, :origin,
                                                                        :statuses_contains)

      set_invoices_search_scope

      return paginate_result if @statuses_contains.nil?

      statuses_filter(@statuses_contains)
      paginate_result
    end

    def search_scope(origin)
      return Invoice if origin.nil?

      if numeric?(origin)
        Invoice.where('number = ?', origin)
      else
        Invoice.joins(:user)
               .joins(:billing_profile)
               .joins(:invoice_items)
               .where('billing_profiles.name ILIKE ? OR ' \
                      'users.email ILIKE ? OR users.surname ILIKE ? OR ' \
                      'invoice_items.name ILIKE ?',
                      "%#{origin}%",
                      "%#{origin}%",
                      "%#{origin}%",
                      "%#{origin}%")
      end
    end

    def numeric?(string)
      return true if string =~ /\A\d+\Z/

      begin
        true if Float(string)
      rescue StandardError
        false
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

    private

    def set_invoices_search_scope
      @invoices = search_scope(@search_string).accessible_by(current_ability)
                                              .includes(:paid_with_payment_order)
                                              .order(orderable_array(default_order_params))
    end

    def statuses_filter(statuses)
      @invoices = @invoices.select { |invoice| statuses.include? invoice.status }
    end

    def paginate_result
      @invoices = Kaminari.paginate_array(@invoices).page(params[:page])
    end

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

    def search_params
      search_params_copy = params.dup
      search_params_copy.permit(:search_string, :full_list, :page,
                                order: {},
                                statuses_contains: [])
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

    def default_order_params
      { 'invoices.due_date' => 'desc', 'invoices.created_at' => 'desc' }
    end
  end
end
# rubocop:enable Metrics/ClassLength
