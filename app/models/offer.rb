class Offer < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user, optional: true
  belongs_to :auction, optional: false
  belongs_to :billing_profile, optional: false

  has_one :result, required: false, dependent: :nullify

  validates :cents, numericality: { only_integer: true, greater_than: 0, less_than: 2**31 }
  validate :auction_must_be_active
  validate :must_be_higher_than_minimum_offer,
           if: proc { |offer| offer&.auction&.platform == 'blind' || offer&.auction&.platform.nil? }
  validate :must_be_higher_that_starting_price
  validate :next_bid_should_be_equal_or_higher_than_min_bid_steps
  validate :validate_accessebly_to_set_bid, on: :create

  DEFAULT_PRICE_VALUE = 1

  after_create_commit :broadcast_replace_auction
  after_update_commit :broadcast_replace_auction

  attr_accessor :skip_autobider, :skip_if_wishlist_case, :skip_validation

  def broadcast_replace_auction
    return if auction.platform == 'blind' || auction.platform.nil?

    Offers::ReplaceBroadcastService.call({ offer: self })
  end

  def validate_accessebly_to_set_bid
    return if auction.nil?
    return if auction.allow_to_set_bid?(user)

    errors.add(:base, 'You need to make deposit first')
  end

  def next_bid_should_be_equal_or_higher_than_min_bid_steps
    return if skip_validation

    auction = Auction.find_by(id: auction_id)
    return if auction.nil? || !auction.english? || auction.offers.empty?

    min_bids_step_in_cents = Money.from_amount(auction.min_bids_step).cents
    return if min_bids_step_in_cents <= cents

    errors.add(:price, 'Next bid should be higher or equal than minimum bid step')
  end

  def must_be_higher_that_starting_price
    auction = Auction.find_by(id: auction_id)
    return if auction.nil? || !auction.english?

    starting_price_in_cents = Money.from_amount(auction.starting_price).cents
    return if starting_price_in_cents <= cents

    errors.add(:price, 'First bid should be more or equal than starting price')
  end

  def auction_must_be_active
    return if skip_if_wishlist_case

    active_auction = Auction.active.find_by(id: auction_id)
    return if active_auction

    if auction&.blind?
      errors.add(:auction, I18n.t('offers.must_be_active'))
    else
      errors.add(:auction, :blank, message: I18n.t('english_offers.must_be_active'))
    end
  end

  def must_be_higher_than_minimum_offer
    minimum_offer = Setting.find_by(code: 'auction_minimum_offer').retrieve
    return if minimum_offer <= cents.to_i

    currency = Setting.find_by(code: 'auction_currency').retrieve
    minimum_offer_as_money = Money.new(minimum_offer, currency)

    errors.add(:price, I18n.t('offers.must_be_higher_than', minimum: minimum_offer_as_money))
  end

  def can_be_modified?
    auction.in_progress?
  end

  def price
    Money.new(cents, Setting.find_by(code: 'auction_currency').retrieve)
  end

  def price=(value)
    number = value.to_d
    price = Money.from_amount(number, Setting.find_by(code: 'auction_currency').retrieve)
    self.cents = price.cents
  end

  def total
    return price * (DEFAULT_PRICE_VALUE + billing_profile.vat_rate) if billing_profile.present?

    default_vat = Countries.vat_rate_from_alpha2_code(user&.country_code || 'EE')
    price * (DEFAULT_PRICE_VALUE + (Invoice.find_by(result: result)&.vat_rate || default_vat))
  end
end
