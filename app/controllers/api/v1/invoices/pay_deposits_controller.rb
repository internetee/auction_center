module Api
  module V1
    module Invoices
      class PayDepositsController < BaseController
        respond_to :json

        skip_before_action :verify_authenticity_token
        before_action :set_auction, only: [:create]

        def create
          response = EisBilling::PayDepositService.call(amount: @auction.deposit,
                                                        customer_url: mobile_payments_deposit_callback_url,
                                                        description:)
          if response.result?
            render json: { oneoff_redirect_link: response.instance['oneoff_redirect_link'] }
          else
            render json: { errors: response.errors }
          end
        end

        private

        def description
          "auction_deposit #{@auction.domain_name}, user_uuid #{current_user.uuid}, " \
            "user_email #{current_user.email}"
        end

        def set_auction
          @auction = Auction.find_by(uuid: params[:id])
        end
      end
    end
  end
end