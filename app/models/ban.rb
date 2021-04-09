class Ban < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :invoice, optional: true

  validates :valid_until, presence: true
  validate :valid_until_later_valid_from

  after_create :remove_offer_from_active_auction
  after_create :remove_offers_from_active_auctions

  def valid_until_later_valid_from
    return unless valid_until
    return if valid_until > (valid_from || Time.zone.now)

    errors.add(:valid_until, 'must be later than valid_from')
  end

  scope :valid, lambda {
    where('valid_until >= ? AND valid_from <= ?', Time.now.utc, Time.now.utc)
  }

  def lift
    destroy!
  end

  def remove_offer_from_active_auction
    auction = Auction.find_by(domain_name: domain_name)
    
    return unless auction.present?
    return unless auction.in_progress?

    user = User.find(user_id)
    offer = user.offers.find_by(auction_id: auction.id)
    offer.destroy if offer.present?
  end

  def remove_offers_from_active_auctions
    ban_number_of_strikes = Setting.find_by(code: 'ban_number_of_strikes')
    user = User.find(user_id)
    if ban_number_of_strikes.value.to_i <= user.bans.count
      user.offers.each do |offer|
        auction_id = offer.auction_id
        auction = Auction.find(auction_id)
        offer.destroy if auction.in_progress?
      end
    end
  end
end
