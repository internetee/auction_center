class PushSubscriptionsController < ApplicationController
  def create
    return unless current_user

    subscription = WebpushSubscription.find_by(user: current_user)
    
    if subscription.present?
      subscription.update(webpush_subscription_params)
    else
      WebpushSubscription.create(webpush_subscription_params.with_defaults(user: current_user))
    end

    render json: { message: 'subsribed' }, status: :created
  end

  private

  def webpush_subscription_params
    params.require(:subscription).permit(:endpoint, :p256dh, :auth)
  end
end
