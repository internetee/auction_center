class AutobiderService
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def self.autobid(auction)
    return unless auction.english?

    bider = new(auction: auction)
    autobiders = bider.auctual_autobiders

    filtered_autobiders = bider.filter_autobider_for_banned_users(autobiders: autobiders)
    filtered_autobiders = bider.reject_autobiders_which_bid_equal_to_auction_current_price(filtered_autobiders: filtered_autobiders, auction: auction)

    return if filtered_autobiders.empty?

    # filtered_ids = filtered_autobiders.group_by(&:cents).map { |cents, autobidders| autobidders.min_by(&:created_at) }.pluck(:id)
    # filtered_autobiders = Autobider.where(id: filtered_ids)

    if filtered_autobiders.size == 1
      bider.autobid_for_single_pericipant(autobider: filtered_autobiders.first)
    elsif filtered_autobiders.size > 1
      bider.autobid_for_multiple_users(autobiders: filtered_autobiders, auction: auction)
    end
  end

  def filter_autobider_for_banned_users(autobiders:)
    collection_ids = autobiders.select { |autobider| restrict_for_banned_user(autobider: autobider) }.pluck(:id)

    Autobider.where(id: collection_ids)
  end

  def reject_autobiders_which_bid_equal_to_auction_current_price(filtered_autobiders:, auction:)
    return filtered_autobiders if auction.offers.empty?

    current_price = auction.highest_price.cents

    collection_ids = filtered_autobiders.select { |autobider| autobider.cents > current_price }.pluck(:id)

    Autobider.where(id: collection_ids)
  end

  def restrict_for_banned_user(autobider:)
    if autobider.user.completely_banned?
      return false
    elsif autobider.user.bans.valid.pluck(:domain_name).include?(autobider.domain_name)
      return false
    end

    true
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
    offer = create_offer(auction: auction, owner: autobider.user, cents: min_bid_step_in_cents)
    auction.update_minimum_bid_step(auction.min_bids_step)
    auction.update_ends_at(offer)
  end

  def outbid_if_exists(autobider:, auction:)
    return if auction.offers.order(updated_at: :asc).last.user == autobider.user

    min_bid_step_in_cents = transform_money_to_cents(auction.min_bids_step)

    if auction.highest_price.cents < autobider.cents
      skip_validation = min_bid_step_in_cents > autobider.cents ? true : false
      min_bid_step_in_cents = min_bid_step_in_cents > autobider.cents ? autobider.cents : min_bid_step_in_cents

      create_or_update_offer(owner: autobider.user,
                             auction: auction,
                             price: min_bid_step_in_cents,
                             skip_validation: skip_validation)

      if skip_validation
        tranformed_money = Money.new(min_bid_step_in_cents)
        auction.update_minimum_bid_step(tranformed_money.to_f, force: true)
      else
        auction.update_minimum_bid_step(auction.min_bids_step)
      end

      auction.reload
      offer = auction.currently_winning_offer
      auction.update_ends_at(offer)

      return
    end

    create_or_update_offer(owner: autobider.user, auction: auction, price: min_bid_step_in_cents)

    auction.update_minimum_bid_step(auction.min_bids_step)
  end

  def autobid_for_multiple_users(autobiders:, auction:)
    highest_price = autobiders.order(cents: :asc).last(2).first.cents
    highest_autobider = autobiders.where('cents >= ?', highest_price).reorder(created_at: :asc).first

    owner = highest_autobider.user

    # last_created_autobider = autobiders.order(:created_at).last
    # owner = last_created_autobider.user if last_created_autobider.cents == highest_price

    # offer = auction.currently_winning_offer
    # return if offer.present? && offer.cents >= highest_price

    offer = create_or_update_offer(owner: owner, auction: auction, price: highest_price)

    money = Money.new(highest_price).to_f
    auction.update_minimum_bid_step(money)
    auction.reload

    higher_autobider = autobiders.order('cents DESC').first

    update_bid_if_somebody_has_higher(highest_autobider: higher_autobider, auction: auction, highest_price: highest_price)
    auction.update_ends_at(offer)
  end

  def update_bid_if_somebody_has_higher(highest_autobider:, auction:, highest_price:)
    highest_autobider_owner = highest_autobider.user
    offer = auction.currently_winning_offer
    last_offer_owner = offer.user

    return if highest_autobider_owner == last_offer_owner
    # return if offer.present? && offer.cents >= highest_price

    min_bid_step_in_cents = transform_money_to_cents(auction.min_bids_step)
    skip_validation = min_bid_step_in_cents > highest_autobider.cents ? true : false
    min_bid_step_in_cents = min_bid_step_in_cents > highest_autobider.cents ? highest_autobider.cents : min_bid_step_in_cents

    offer = create_or_update_offer(owner: highest_autobider_owner,
                                   auction: auction,
                                   price: min_bid_step_in_cents,
                                   skip_validation: skip_validation)

    if skip_validation
      tranformed_money = Money.new(min_bid_step_in_cents)

      auction.update_minimum_bid_step(tranformed_money.to_f, force: true)
    else
      auction.update_minimum_bid_step(auction.min_bids_step)
    end

    auction.update_ends_at(offer)
  end

  def transform_money_to_cents(money)
    Money.from_amount(money.to_d, Setting.find_by(code: 'auction_currency').retrieve).cents
  end

  def create_or_update_offer(owner:, auction:, price:, skip_validation: false)
    user_offer = auction.offers.find_by(user: owner)
    if user_offer.nil?
      user_offer = create_offer(auction: auction, owner: owner, cents: price)
    else
      user_offer.update!(cents: price, skip_autobider: true, skip_validation: skip_validation)
    end

    user_offer
  end

  def create_offer(auction:, owner:, cents:)
    Offer.create!(
      auction: auction,
      user: owner,
      cents: cents,
      billing_profile: owner.billing_profiles.first,
      username: Username::GenerateUsernameService.new.call
    )
  end
end
