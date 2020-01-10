class OfferGenerator
  RANGE_START = Time.zone.now - 6.months

  def self.generate! count
    count.times do
      self.new.create!
    end
  end

  def create!
    auction = Auction.all.sample
    rand(6).times do
      user = User.participant.with_billing_profiles.sample

      offer = Offer.new(
        auction: auction,
        user: user,
        cents: auction.offers.pluck(:cents).max.to_i + 1000,
        billing_profile: user.billing_profiles.sample,
        uuid: SecureRandom.uuid
      )
      offer.save!(validate: false)
    end
  end
end

OfferGenerator.generate! Auction.all.count - (Auction.all.count / 5)
