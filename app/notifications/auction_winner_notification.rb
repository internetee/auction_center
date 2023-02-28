# To deliver this notification:
#
# OfferNotification.with(post: @post).deliver_later(current_user)
# OfferNotification.with(post: @post).deliver(current_user)

class AuctionWinnerNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :auction

  def message
    I18n.t('.participant_win_auction', name: params[:auction].domain_name)
  end

  # Define helper methods to make rendering easier.
  #
  # def message
  #   t(".message")
  # end
  #
  # def url
  #   post_path(params[:post])
  # end
end
