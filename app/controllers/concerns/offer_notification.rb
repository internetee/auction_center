module OfferNotification
  extend ActiveSupport::Concern

  included do
    after_action :send_outbided_notification, only: [:create, :update]
    # after_action :send_outbided_notification_after_create, only: [:create]
  end

  def send_outbided_notification
    auction = Auction.find(params[:offer][:auction_id])
    return if auction.offers.empty?

    # @offer = Offer.where(user_id: current_user.id)
                  # .find_by!(uuid: params[:uuid])
    # participant_ids = []
    # last_participant_id = auction&.currently_winning_offer&.user_id
    # participant_ids = auction.offers.pluck(:user_id) - [last_participant_id] if last_participant_id.present?

    offer = auction.offers.last
    participant_ids = auction.offers.pluck(:user_id) - [current_user.id]
    participants = User.where(id: participant_ids)
    participants.each do |participant|
      p '---'
      p offer
      p '-'
      OfferNotification.with(offer: offer).deliver_later(participant)
    end
  end

  # def send_outbided_notification_after_create
  #   @auction = Auction.find(params[:offer][:auction_id])
  #   return if auction.offers.empty?


  # end
end
