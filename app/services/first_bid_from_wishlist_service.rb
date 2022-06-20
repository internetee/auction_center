class FirstBidFromWishlistService
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def self.apply_bid(auction:)
    bidder = new(auction: auction)
    bidder.apply_bids_from_wishlists
  end

  def apply_bids_from_wishlists
    wishlists = WishlistItem.where(domain_name: auction.domain_name)
    return if wishlists.empty? || !any_starting_bids?(wishlists)

    maximum_bid = wishlists.maximum(:cents)

    return unless starting_bid_fine?(maximum_bid) if auction.english?

    create_offers_for_starting_bids(wishlists: wishlists, maximum_bid: maximum_bid)

    money = Money.new(maximum_bid).to_f
    auction.update_minimum_bid_step(money)
  end

  def any_starting_bids?(wishlists)
    wishlists.any? { |wish| wish.cents.present? }
  end

  def starting_bid_fine?(maximum_bid)
    false if auction.starting_price.nil?

    auction_starting_price = Money.from_amount(auction.starting_price).cents
    auction_starting_price < maximum_bid
  end

  def create_offers_for_starting_bids(wishlists:, maximum_bid:)
    actual_wishlists = wishlists.select { |item| item.cents == maximum_bid }

    if actual_wishlists.size == 1
      create_offer(auction: auction, owner: actual_wishlists.first.user, cents: maximum_bid)
    elsif actual_wishlists.size > 1
      sorted_items = actual_wishlists.sort_by(&:updated_at)
      create_offer(auction: auction, owner: sorted_items.first.user, cents: maximum_bid)
    end
  end

  def create_offer(auction:, owner:, cents:)
    Offer.create!(
      auction: auction,
      user: owner,
      cents: cents,
      billing_profile: owner.billing_profiles.first,
      skip_if_wishlist_case: true
    )
  end
end
