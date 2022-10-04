class WishlistMailerPreview < ActionMailer::Preview
  def auction_notification_mail_english
    user = User.new(email: 'some@email.com', locale: :en,
                    given_names: 'GivenNames', surname: 'Surname')
    auction = Auction.new(domain_name: 'example.test', ends_at: Time.zone.now,
                          uuid: SecureRandom.uuid)
    item = WishlistItem.new(user: user, domain_name: auction.domain_name)

    WishlistMailer.auction_notification_mail(item, auction)
  end

  def auction_notification_mail_estonian
    user = User.new(email: 'some@email.com', locale: :et,
                    given_names: 'GivenNames', surname: 'Surname')
    auction = Auction.new(domain_name: 'example.test', ends_at: Time.zone.now,
                          uuid: SecureRandom.uuid)
    item = WishlistItem.new(user: user, domain_name: auction.domain_name)

    WishlistMailer.auction_notification_mail(item, auction)
  end

  def auto_offer_notification_mail_english
    user = User.new(email: 'some@email.com', locale: :en,
                    given_names: 'GivenNames', surname: 'Surname')
    auction = Auction.new(domain_name: 'example.test', ends_at: Time.zone.now,
                          uuid: SecureRandom.uuid)
    item = WishlistItem.new(user: user, domain_name: auction.domain_name, cents: 5000)
    offer = Offer.last

    WishlistMailer.auto_offer_notification_mail(item, auction, offer)
  end

  def auto_offer_notification_mail_estonian
    user = User.new(email: 'some@email.com', locale: :et,
                    given_names: 'GivenNames', surname: 'Surname')
    auction = Auction.new(domain_name: 'example.test', ends_at: Time.zone.now,
                          uuid: SecureRandom.uuid)
    item = WishlistItem.new(user: user, domain_name: auction.domain_name)
    offer = Offer.last

    WishlistMailer.auto_offer_notification_mail(item, auction, offer)
  end
end
