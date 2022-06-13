class AutobiderService
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def self.autobid(auction)
    return unless auction.english?

    bider = new(auction: auction)
    autobiders = bider.auctual_autobiders

    return if autobiders.empty?

    if autobiders.size == 1
      bider.autobid_for_single_pericipant(autobider: autobiders.first)
    elsif autobiders.size > 1
      bider.autobid_for_multiple_users(autobiders: autobiders, auction: auction)
    end
  end

  def auctual_autobiders
    maximum_hight_offer_in_price = auction.offers.maximum(:cents) || 0
    Autobider.where('domain_name = ? AND cents >= ?', auction.domain_name, maximum_hight_offer_in_price)
  end

  def autobid_for_single_pericipant(autobider:)
    if auction.offers.empty?
      create_first_bid(autobider: autobider, auction: auction)
    else
      outbid_if_exists(autobider: autobider, auction: auction)
    end
  end

  def create_first_bid(autobider:, auction:)
    starting_price_translated = Money.from_amount(auction.starting_price.to_d,
                                                  Setting.find_by(code: 'auction_currency').retrieve)
    return if autobider.cents < starting_price_translated.cents

    min_bid_step_in_cents = transform_money_to_cents(auction.min_bids_step)
    create_offer(auction: auction, owner: autobider.user, cents: min_bid_step_in_cents)
    auction.update_minimum_bid_step(auction.min_bids_step)
  end

  def outbid_if_exists(autobider:, auction:)
    return if auction.offers.order(updated_at: :asc).last.user == autobider.user

    min_bid_step_in_cents = transform_money_to_cents(auction.min_bids_step)
    create_or_update_offer(owner: autobider.user, auction: auction, price: min_bid_step_in_cents)

    auction.update_minimum_bid_step(auction.min_bids_step)
  end

  def autobid_for_multiple_users(autobiders:, auction:)
    highest_price = autobiders.order(cents: :asc).last(2).first.cents
    owner = autobiders.where('cents >= ?', highest_price).reorder(created_at: :asc).first.user

    create_or_update_offer(owner: owner, auction: auction, price: highest_price)

    money = Money.new(highest_price).to_f
    auction.update_minimum_bid_step(money)
    auction.reload

    update_bid_if_somebody_has_higher(autobiders: autobiders, auction: auction)
  end

  def update_bid_if_somebody_has_higher(autobiders:, auction:)
    autobider_owner_with_highest_cents = autobiders.order(cents: :asc).last.user
    last_offer_owner = auction.offers.order(updated_at: :desc).first.user

    return if autobider_owner_with_highest_cents == last_offer_owner

    min_bid_step_in_cents = transform_money_to_cents(auction.min_bids_step)
    create_or_update_offer(owner: autobider_owner_with_highest_cents, auction: auction, price: min_bid_step_in_cents)
    auction.update_minimum_bid_step(auction.min_bids_step)
  end

  def transform_money_to_cents(money)
    Money.from_amount(money.to_d, Setting.find_by(code: 'auction_currency').retrieve).cents
  end

  def create_or_update_offer(owner:, auction:, price:)
    user_offer = auction.offers.find_by(user: owner)
    if user_offer.nil?
      create_offer(auction: auction, owner: owner, cents: price)
    else
      user_offer.update!(cents: price, skip_autobider: true)
    end
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
