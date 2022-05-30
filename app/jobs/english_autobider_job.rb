class EnglishAutobiderJob < ApplicationJob
  def perform(auction_id)
    auction = Auction.find(auction_id)
    retrun unless auction.english?

    maximum_hight_offer_in_price = auction.offers.maximum(:cents)

    wishlist_items = WishlistItem.where(domain_name: auction.domain_name).where('highest_bid >= ?', maximum_hight_offer_in_price)

    if wishlist_items.size > 1
      item = wishlist_items.order(highest_bid: :asc, created_at: :asc).first
      user_offer = Offer.find_by(auction_id: auction.id, user_id: item.user.id)

      return if user_offer.nil?

      user_offer.update!(cents: item.highest_bid, skip_autobider: true)
    elsif wishlist_items.size == 1
      wishlist_instance = wishlist_items.first
      user_offer = Offer.find_by(auction_id: auction.id, user_id: wishlist_instance.user.id)

      owner_of_last_offer = auction.offers.order(updated_at: :asc).last.user
      return if owner_of_last_offer == wishlist_instance.user

      min_bid_step = auction.min_bids_step
      min_bid_step_translated = Money.from_amount(min_bid_step.to_d, Setting.find_by(code: 'auction_currency').retrieve)

      if min_bid_step_translated.cents < wishlist_instance.highest_bid
        user_offer.update!(cents: min_bid_step_translated.cents, skip_autobider: true)
        auction.update_minimum_bid_step(min_bid_step)
      else
        user_offer.update!(cents: wishlist_instance.highest_bid, skip_autobider: true)
        auction.update_minimum_bid_step(min_bid_step)
      end
    end
  end
end
