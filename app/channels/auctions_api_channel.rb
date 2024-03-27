class AuctionsApiChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info 'Client subscribed to AuctionsChannel'
    stream_from 'auctions_api'
  end

  def unsubscribed
    Rails.logger.info 'Client unsubscribed from AuctionsChannel'
    # Any cleanup needed when channel is unsubscribed
  end
end
