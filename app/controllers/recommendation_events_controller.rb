class RecommendationEventsController < ApplicationController
  before_action :authenticate_user!

  def create
    Recommendation::EventTracker.call(
      user: current_user,
      auction: auction,
      event_type: recommendation_event_params[:event_type],
      source: recommendation_event_params[:source],
      properties: recommendation_event_params[:properties],
      request:
    )

    head :created
  end

  private

  def auction
    return if recommendation_event_params[:auction_uuid].blank?

    Auction.find_by(uuid: recommendation_event_params[:auction_uuid])
  end

  def recommendation_event_params
    params.require(:recommendation_event)
          .permit(:event_type, :source, :auction_uuid, properties: {})
  end
end
