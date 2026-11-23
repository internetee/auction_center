class MontonioController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[callback]

  # Montonio redirects the payer back here after the payment and appends an `order-token`
  # query parameter. That parameter is deliberately ignored: the authoritative payment
  # confirmation arrives asynchronously from the billing system via
  # PUT /eis_billing/payment_status.
  def callback
    redirect_to invoices_path(state: 'payment')
  end
end
