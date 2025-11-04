# To deliver this notification:
#
# AuctionLooserNotification.with(auction: @auction).deliver_later(current_user)
# AuctionLooserNotification.with(auction: @auction).deliver(current_user)

class AuctionLooserNotification < Noticed::Base
  deliver_by :database
  deliver_by :webpush, class: 'DeliveryMethods::Webpush', format: :webpush_format

  param :auction

  def webpush_format
    auction = params[:auction]

    {
      title: I18n.t('.webpush_title_lost'),
      body: I18n.t('.participant_lost_auction', name: params[:auction]&.domain_name),
      icon: 'https://example.com/icon.png'
    }
  end

  def message
    I18n.t('.participant_lost_auction', name: params[:auction]&.domain_name)
  end
end
