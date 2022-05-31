class EnglishAutobiderJob < ApplicationJob
  def perform(auction_id, user_id)
    auction = Auction.find(auction_id)
    user = User.find(user_id)
    retrun unless auction.english?

    maximum_hight_offer_in_price = auction.offers.maximum(:cents)

    wishlist_items = WishlistItem.where(domain_name: auction.domain_name).where('highest_bid >= ?',
                                                                                maximum_hight_offer_in_price)

    if wishlist_items.size > 1
      item = wishlist_items.order(highest_bid: :asc, created_at: :asc).first
      user_offer = Offer.find_by(auction_id: auction.id, user_id: item.user.id)

      return if user_offer.nil?

      user_offer.update!(cents: item.highest_bid, skip_autobider: true)
    elsif wishlist_items.size == 1
      increase_bid_for_single_user(wishlist_instance: wishlist_items.first, auction: auction, user: user)
    end
  end

  private

  def increase_bid_for_single_user(wishlist_instance:, auction:, user:)
    user_offer = Offer.find_by(auction_id: auction.id, user_id: wishlist_instance.user.id)

    owner_of_last_offer = auction.offers.order(updated_at: :asc).last.user
    return if owner_of_last_offer == wishlist_instance.user

    min_bid_step = auction.min_bids_step
    min_bid_step_translated = Money.from_amount(min_bid_step.to_d, Setting.find_by(code: 'auction_currency').retrieve)

    if min_bid_step_translated.cents < wishlist_instance.highest_bid
      if user_offer.nil?
        increse_bid_per_minimum_bid_step(auction: auction, user: user, min_bid_step: min_bid_step, min_bid_step_translated: min_bid_step_translated)
      else
        user_offer.update!(cents: min_bid_step_translated.cents, skip_autobider: true)
        auction.update_minimum_bid_step(min_bid_step)
      end
    else
      user_offer.update!(cents: wishlist_instance.highest_bid, skip_autobider: true)
      auction.update_minimum_bid_step(min_bid_step)
    end
  end

  def increse_bid_per_minimum_bid_step(auction:, user:, min_bid_step:, min_bid_step_translated:)
    auction_current_user_offer = Offer.find_by(auction_id: auction.id, user_id: user.id)
    if auction_current_user_offer.nil?
      Offer.create!(
        auction: auction,
        user: user,
        cents: min_bid_step_translated.cents,
        billing_profile: user.billing_profiles.first
      )
    else
      auction_current_user_offer.update!(cents: min_bid_step_translated.cents, skip_autobider: true)
    end
    auction.update_minimum_bid_step(min_bid_step)
  end
end
