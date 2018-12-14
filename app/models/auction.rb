class Auction < ApplicationRecord
  validates :domain_name, presence: true
  validates :ends_at, presence: true
  validates :starts_at, presence: true

  validate :does_not_overlap
  validate :ends_at_later_than_starts_at
  validate :starts_at_cannot_be_in_the_past, on: :create

  has_many :offers, dependent: :delete_all
  has_one :result, required: false, dependent: :delete

  scope :active, -> { where('starts_at <= ? AND ends_at >= ?', Time.now.utc, Time.now.utc) }
  scope :without_result, lambda {
    where('ends_at < ? and id NOT IN (SELECT results.auction_id FROM results)', Time.now.utc)
  }

  delegate :count, to: :offers, prefix: true

  def does_not_overlap
    return unless starts_at && ends_at
    return unless overlaping_auctions&.exists?

    errors.add(:starts_at, 'overlaps with another auction')
    errors.add(:ends_at, 'overlaps with another auction')
  end

  def starts_at_cannot_be_in_the_past
    return unless starts_at
    return if starts_at >= Time.now.utc

    errors.add(:starts_at, 'cannot be in the past')
  end

  def highest_price
    return unless offers.any?

    offers.order(cents: :desc).limit(1).first.price
  end

  # As the name suggests, this method return the offer that is currently the highest.
  # The following case might occur:
  # Auction `auction` has two offers, A (50.00) and B (5.00). When an auction expires, offer A
  # is the winner.
  # auction.currently_winning_offer -> Offer A

  # After a few month, user who made offer A decides that he no longer
  # needs an account in the auction center, so he deletes it. Now, offer B is the winner,
  # even if the domain was already registered to the user A.
  def currently_winning_offer
    offers.where('user_id IS NOT NULL').order(cents: :desc, created_at: :desc).first
  end

  def current_price_from_user(user_id)
    offers_query = offers.where(user_id: user_id)
    return unless offers_query.any?

    offers_query.order(cents: :desc).first.price
  end

  def offer_from_user(user_id)
    offers.where(user_id: user_id).order(cents: :desc).first
  end

  def ends_at_later_than_starts_at
    return unless starts_at && ends_at
    return if ends_at > starts_at

    errors.add(:starts_at, 'must be earlier than ends_at')
  end

  def overlaping_auctions
    dates_order = [starts_at, ends_at].sort
    if persisted?
      sql = <<~SQL.squish
        id <> ? and domain_name = ?
        AND tsrange(starts_at, ends_at, '[]') && tsrange(?, ?, '[]')
      SQL

      Auction.where(sql, id, domain_name, dates_order.first, dates_order.second)
    else
      sql = "domain_name = ? AND tsrange(starts_at, ends_at, '[]') && tsrange(?, ?, '[]')"

      Auction.where(sql, domain_name, dates_order.first, dates_order.second)
    end
  end

  def can_be_deleted?
    if valid?
      !in_progress? && !finished?
    else
      false
    end
  end

  def finished?
    if valid?
      Time.now.utc > ends_at
    else
      false
    end
  end

  def in_progress?
    if valid?
      Time.now.utc > starts_at && !finished?
    else
      false
    end
  end
end
