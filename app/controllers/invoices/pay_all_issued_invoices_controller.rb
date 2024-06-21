class Invoices::PayAllIssuedInvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user

  def create
    issued_invoices = Invoice.accessible_by(current_ability)
                             .where(user_id: current_user.id).to_a.select(&:issued?)

    response = EisBilling::BulkInvoicesService.call(invoices: issued_invoices,
                                                    customer_url: linkpay_callback_url)

    if response.result?
      redirect_to response.instance['oneoff_redirect_link'], allow_other_host: true
    else
      flash.alert = response.errors
      redirect_to invoices_path and return
    end
  end

  def authorize_user
    authorize! :read, Invoice
    authorize! :update, Invoice
  end
end
