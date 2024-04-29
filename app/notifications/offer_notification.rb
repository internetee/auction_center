# To deliver this notification:
#
# OfferNotification.with(offer: @offer).deliver_later(current_user)
# OfferNotification.with(offer: @offer).deliver(current_user)

class OfferNotification < Noticed::Base
  deliver_by :database
  deliver_by :webpush, class: 'DeliveryMethods::Webpush', format: :webpush_format

  param :offer

  def webpush_format
    {
      title: I18n.t('.webpush_title_outbidded'),
      body: I18n.t('.participant_outbid_broadcast', name: params[:offer]&.auction&.domain_name),
      icon: 'https://example.com/icon.png'
    }
  end

  def message
    return unless params.is_a?(Hash)
    return if params[:offer].blank?

    I18n.t('.participant_outbid_broadcast', name: params[:offer]&.auction&.domain_name)
  end
end
