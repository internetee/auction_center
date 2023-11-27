module Api
  class StreamNamesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def show
      stream_name = 'auctions'
      signed_stream_name = ActionCable.server.pubsub.signed_stream_identifier(stream_name)

      render json: { signed_stream_name: }
    end
  end
end
