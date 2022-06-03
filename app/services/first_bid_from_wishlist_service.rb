class FirstBidFromWishlistService
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def self.set_bid(auction:)
    bidder = new(auction: auction)
    bidder.get_actual_wishlists
  end

  def get_actual_wishlists
    wishlists = WishlistItem.where(domain_name: auction.domain_name)
    return if wishlists.empty?

    maximum_bid = wishlists.maximum(:cents)

    auction_starting_price = Money.from_amount(auction.starting_price).cents unless auction.starting_price.nil?
    return if !auction.starting_price.nil? && auction_starting_price > maximum_bid

    actual_wishlists = wishlists.select { |item| item.cents == maximum_bid }

    money = Money.new(maximum_bid).to_f
    if actual_wishlists.size == 1
      create_offer(auction: auction, owner: actual_wishlists.first.user, cents: maximum_bid)
    elsif actual_wishlists.size > 1
      sorted_items = actual_wishlists.sort_by(&:updated_at)
      create_offer(auction: auction, owner: sorted_items.first.user, cents: maximum_bid)
    end

    auction.update_minimum_bid_step(money)
  end

  def create_offer(auction:, owner:, cents:)
    Offer.create!(
      auction: auction,
      user: owner,
      cents: cents,
      billing_profile: owner.billing_profiles.first
    )
  end
end
