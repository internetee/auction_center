module OfferNotifable
  extend ActiveSupport::Concern

  def send_outbided_notification(auction:, offer:, flash:)
    participant_id = last_higher_bidder(auction)
    participant = User.find(participant_id)

    OfferNotification.with(offer: offer).deliver_later(participant) if offer.present?

    flash[:notice] = "websocket_domain_name, #{auction.domain_name}"
    broadcast_outbid_to_notifications(participant: participant, flash: flash)
  end

  def last_higher_bidder(auction)
    auction.offers.order(cents: :desc).limit(2).pluck(:user_id) - [current_user.id]
  end

  def broadcast_outbid_to_notifications(participant:, flash:)
    Turbo::StreamsChannel.broadcast_update_to(
      [participant, :flash], target: 'flash-notice', partial: 'common/flash', locals: { flash: flash}
    )
  end
end
