module OfferNotifable
  extend ActiveSupport::Concern

  def send_outbided_notification(auction:, offer:, flash:)
    participant_ids = auction.offers.pluck(:user_id) - [current_user.id]
    participants = User.where(id: participant_ids)
    participants.each do |participant|
      OfferNotification.with(offer: @offer).deliver_later(participant)
      # flash[:notice] = I18n.t('.participant_outbid', name: auction.domain_name)
      flash[:notice] = "websocket_domain_name, #{auction.domain_name}"
      broadcast_outbid_to_notifications(participant: participant, flash: flash)
    end
  end

  def broadcast_outbid_to_notifications(participant:, flash:)
    Turbo::StreamsChannel.broadcast_update_to(
      [participant, :flash], target: 'flash-notice', partial: 'common/flash', locals: { flash: flash }
    )
  end
end
