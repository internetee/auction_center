class WishlistMailer < ApplicationMailer
  def auction_notification_mail(item, auction)
    @user = item.user
    @auction = auction
    I18n.locale = @user.locale

    mail(to: @user.email, subject: t('.subject', domain_name: item.domain_name))
  end

  def auto_offer_notification_mail(item, auction, offer)
    @user = item.user
    @auction = auction
    @offer = offer
    I18n.locale = @user.locale

    mail(to: @user.email, subject: t('.subject', domain_name: item.domain_name))
  end
end
