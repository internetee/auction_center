module Api
  class StreamNamesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def show
      # stream_name = 'auctions'
      # signed_stream_name = ActionCable.server.signed_stream_identifier(stream_name)
      signed_stream_name = Turbo::StreamsChannel.signed_stream_name 'auctions'

      render json: { signed_stream_name: }
    end
  end
end
