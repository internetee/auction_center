# To deliver this notification:
#
# AuctionWinnerNotification.with(auction: @auction).deliver_later(current_user)
# AuctionWinnerNotification.with(auction: @auction).deliver(current_user)

class AuctionWinnerNotification < Noticed::Base
  deliver_by :database
  deliver_by :webpush, class: 'DeliveryMethods::Webpush', format: :webpush_format

  param :auction

  def webpush_format
    auction = params[:auction]

    {
      title: I18n.t('.winner_webpush_notification_title'),
      body: I18n.t('.participant_win_auction', name: params[:auction].domain_name),
      icon: 'https://example.com/icon.png'
    }
  end

  def message
    I18n.t('.participant_win_auction', name: params[:auction].domain_name)
  end
end
