class AuctionResultMailer < ApplicationMailer
  def winner_email(result)
    @user = result.user
    @auction = result.auction
    @price = result.price

    mail(to: @user.email, subject: t('.subject'))
  end
end
