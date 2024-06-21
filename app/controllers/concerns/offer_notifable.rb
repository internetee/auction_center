module OfferNotifable
  extend ActiveSupport::Concern

  def send_outbided_notification(auction:, offer:, flash:)
    participant_ids = last_higher_bidder(auction)
    participants = User.where(id: participant_ids)

    participants.each do |participant|
      prepend_data(participant:, auction:, offer:, flash:)
    end
  end

  private

  def last_higher_bidder(auction)
    auction.offers.order(cents: :desc).limit(2).pluck(:user_id) - [current_user.id]
  end

  def prepend_data(participant:, auction:, offer:, flash:)
    I18n.with_locale(participant.locale || I18n.default_locale) do
      OfferNotification.with(offer:).deliver_later(participant) if offer.present?

      flash[:notice] = I18n.t('.participant_outbid', domain_name: auction.domain_name)
      broadcast_outbid_to_notifications(participant:, flash:)
    end
  end

  def broadcast_outbid_to_notifications(participant:, flash:)
    Turbo::StreamsChannel.broadcast_update_to(
      [participant, :flash], target: 'flash-notice', partial: 'common/flash', locals: { flash: }
    )
  end
end
