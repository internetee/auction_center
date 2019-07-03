class WishlistMailerPreview < ActionMailer::Preview
  def auction_notification_mail_english
    user = User.new(email: 'some@email.com', locale: :en)
    auction = Auction.new(domain_name: 'example.test', ends_at: Time.zone.now,
                          uuid: SecureRandom.uuid)
    item = WishlistItem.new(user: user, domain_name: auction.domain_name)

    WishlistMailer.auction_notification_mail(item, auction)
  end

  def auction_notification_mail_estonian
    user = User.new(email: 'some@email.com', locale: :et)
    auction = Auction.new(domain_name: 'example.test', ends_at: Time.zone.now,
                          uuid: SecureRandom.uuid)
    item = WishlistItem.new(user: user, domain_name: auction.domain_name)

    WishlistMailer.auction_notification_mail(item, auction)
  end
end
