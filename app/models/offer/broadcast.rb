module Offer::Broadcast
  extend ActiveSupport::Concern

  included do
    after_create_commit :broadcast_replace_auction
    after_update_commit :broadcast_replace_auction  
  end

  def broadcast_replace_auction
    return if auction.platform == 'blind' || auction.platform.nil?

    Offers::ReplaceBroadcastService.call({ offer: self })
  end
end
