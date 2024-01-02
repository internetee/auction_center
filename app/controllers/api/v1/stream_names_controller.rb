module Api
  module V1
    class StreamNamesController < ApplicationController
      skip_before_action :verify_authenticity_token

      def show
        signed_stream_name = Turbo::StreamsChannel.signed_stream_name 'auctions'

        render json: { signed_stream_name: }
      end
    end
  end
end
