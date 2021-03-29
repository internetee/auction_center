class LinkpayController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[return callback]

  def callback
    logger.info params
    render status: :ok, json: { status: 'ok' }
  end
end
