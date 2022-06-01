class EnglishAutobiderJob < ApplicationJob
  def perform(auction_id, user_id)
    auction = Auction.find(auction_id)
    user = User.find(user_id)
    retrun unless auction.english?

    maximum_hight_offer_in_price = auction.offers.maximum(:cents)

    wishlist_items = WishlistItem.where(domain_name: auction.domain_name).where('highest_bid >= ?',
                                                                                maximum_hight_offer_in_price)

    if wishlist_items.size > 1
      multiple_wishlist_participants(wishlist_items: wishlist_items, auction: auction)
    elsif wishlist_items.size == 1
      increase_bid_for_single_user(wishlist_instance: wishlist_items.first, auction: auction, user: user)
    end
  end

  private

  # def increase_bid_for_multi_users(wishlist_items:, auction:)
  #   item = wishlist_items.order(highest_bid: :asc, created_at: :asc).first
  #   user_offer = Offer.find_by(auction_id: auction.id, user_id: item.user.id)

  #   return if user_offer.nil?

  #   user_offer.update!(cents: item.highest_bid, skip_autobider: true)
  # end

  def multiple_wishlist_participants(wishlist_items:, auction:)
    highest_bid = wishlist_items.order(highest_bid: :asc).last(2).first.highest_bid
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
