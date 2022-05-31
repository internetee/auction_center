class SetHighestBidJob < ApplicationJob
  def perform(auction_id)
    auction = Auction.find(auction_id)
    return unless auction.english?

    wishlist_items = WishlistItem.where(domain_name: auction.domain_name).where.not(highest_bid: nil).order(highest_bid: :asc)

    if wishlist_items.present? && wishlist_items.size > 1
      multiple_wishlist_participants(wishlist_items: wishlist_items, auction: auction)
    elsif wishlist_items.present? && wishlist_items.size == 1
      single_wishlist_participant(wishlist_instance: wishlist_items.first, auction: auction)
    end

    if wishlist_items.empty?
      wishlist_items_collection = WishlistItem.where(domain_name: auction.domain_name).where.not(cents: nil).order(cents: :asc)
      return if wishlist_items_collection.empty?

      if wishlist_items_collection.size == 1
        single_wishlist_participant(wishlist_instance: wishlist_items_collection.first, auction: auction)
      else
        first_bid_for_multiple_participants(auction: auction, wishlist_items_collection: wishlist_items_collection)
      end
    end
  end

  private

  def first_bid_for_multiple_participants(auction:, wishlist_items_collection:)
    wishlist_instance = wishlist_items_collection.last

    Offer.create!(
      auction: auction,
      user: wishlist_instance.user,
      cents: wishlist_instance.cents,
      billing_profile: wishlist_instance.user.billing_profiles.first
    )

    money = Money.new(wishlist_instance.cents).to_f
    auction.update_minimum_bid_step(money)
  end

  def multiple_wishlist_participants(wishlist_items:, auction:)
    highest_bid = wishlist_items.last(2).first.highest_bid
    owner = wishlist_items.where('highest_bid >= ?', highest_bid).reorder(created_at: :asc).first.user

    Offer.create!(
      auction: auction,
      user: owner,
      cents: highest_bid,
      billing_profile: owner.billing_profiles.first
    )

    money = Money.new(highest_bid).to_f
    auction.update_minimum_bid_step(money)
    auction.reload

    update_bid_if_somebody_has_higher(wishlist_items: wishlist_items, auction: auction)
  end

  def update_bid_if_somebody_has_higher(wishlist_items:, auction:)
    the_most_higher_wishlist_owner = wishlist_items.order(highest_bid: :asc).last.user
    last_offer_owner = auction.offers.order(updated_at: :desc).first.user

    return if the_most_higher_wishlist_owner == last_offer_owner

    min_bid_step = auction.min_bids_step
    min_bid_step_translated = Money.from_amount(min_bid_step.to_d, Setting.find_by(code: 'auction_currency').retrieve)

    Offer.create!(
      auction: auction,
      user: the_most_higher_wishlist_owner,
      cents: min_bid_step_translated.cents,
      billing_profile: the_most_higher_wishlist_owner.billing_profiles.first
    )

    auction.update_minimum_bid_step(min_bid_step)
  end

  def single_wishlist_participant(wishlist_instance:, auction:)
    return if wishlist_instance.cents.nil? && wishlist_instance.highest_bid.nil?
    return if wishlist_instance.cents == 0 && wishlist_instance.highest_bid == 0

    auction_starting_price = Money.from_amount(auction.starting_price).cents

    if wishlist_instance.cents.nil?
      return wishlist_instance.highest_bid < auction_starting_price

      Offer.create!(
        auction: auction,
        user: wishlist_instance.user,
        cents: auction.starting_price,
        billing_profile: wishlist_instance.user.billing_profiles.first
      )

      auction.update_minimum_bid_step(auction.starting_price)
    else
      return if wishlist_instance.cents < auction_starting_price

      Offer.create!(
        auction: auction,
        user: wishlist_instance.user,
        cents: wishlist_instance.cents,
        billing_profile: wishlist_instance.user.billing_profiles.first
      )

      money = Money.new(wishlist_instance.cents).to_f
      auction.update_minimum_bid_step(money)
    end
  end
end
