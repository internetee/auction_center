class RecommendationEventsController < ApplicationController
  # The browser may only report clicks; every other event type is recorded
  # server-side by the action that actually happened (bid, wishlist, profile).
  CLIENT_EVENT_TYPES = %w[auction_click].freeze
  SOURCE_MAX_LENGTH = 64

  before_action :authenticate_user!
  rate_limit to: 60, within: 1.minute, by: -> { current_user.id }, only: :create

  def create
    return head :unprocessable_entity unless CLIENT_EVENT_TYPES.include?(event_params[:event_type]) && auction

    Recommendation::EventTracker.call(
      user: current_user,
      auction:,
      event_type: event_params[:event_type],
      source: event_params[:source].to_s.first(SOURCE_MAX_LENGTH).presence,
      request:
    )

    head :created
  end

  private

  def auction
    return @auction if defined?(@auction)

    @auction = event_params[:auction_uuid].present? && Auction.find_by(uuid: event_params[:auction_uuid])
  end

  def event_params
    params.require(:recommendation_event).permit(:event_type, :source, :auction_uuid)
  end
end
