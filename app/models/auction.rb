class Auction < ApplicationRecord
  include Presentable
  include PgSearch::Model

  BLIND = '0'.freeze

  after_create :find_auction_turns
  validates :domain_name, presence: true

  attr_accessor :skip_broadcast, :skip_validation

  validate :does_not_overlap, unless: :skip_validation
  validate :ends_at_later_than_starts_at
  validate :starts_at_cannot_be_in_the_past, on: :create
  validate :enable_deposit_only_for_english_auction, on: :update
  validate :deposit_and_enable_deposit_should_be_togeter, on: :update

  has_many :offers, dependent: :delete_all
  has_many :domain_participate_auctions
  has_one :result, required: false, dependent: :destroy

  enum platform: %i[blind english]

  after_update_commit :update_list_broadcast, unless: :skip_broadcast
  after_update_commit :update_offer_broadcast, unless: :skip_broadcast

  scope :active, -> { where('starts_at <= ? AND ends_at >= ?', Time.now.utc, Time.now.utc) }
  scope :without_result, lambda {
    where('ends_at < ? and id NOT IN (SELECT results.auction_id FROM results)', Time.now.utc)
  }

  scope :for_period, lambda { |start_date, end_date|
    where(ends_at: start_date.beginning_of_day..end_date.end_of_day)
  }

  scope :without_offers, -> { self.includes(:offers).where(offers: { auction_id: nil }) }
  scope :with_offers, -> { self.includes(:offers).where.not(offers: { auction_id: nil }) }
  scope :with_domain_name, ->(domain_name) do
    return unless domain_name.present?

    self.where('domain_name like ?', "%#{domain_name}%")
  end

  scope :with_type, ->(type) do
    if type.present?
      return self.where(platform: [type, nil]) if type == BLIND

      self.where(platform: type)
    end
  end

  scope :with_starts_at, ->(starts_at) do
    self.where('starts_at >= ?', starts_at.to_date.beginning_of_day) if starts_at.present?
  end

  scope :with_ends_at, ->(ends_at) { self.where('ends_at <= ?', ends_at.to_date.end_of_day) if ends_at.present? }
  scope :with_starts_at_nil, ->(state) { self.where(starts_at: nil) if state.present? }

  scope :english, -> { self.where(platform: :english) }
  scope :not_english, -> { self.where.not(platform: :english) }

  scope :with_offers, ->(auction_offer_type, type) do
    return if auction_offer_type.blank? || type == BLIND || type.empty?

    case auction_offer_type
    when 'with_offers'
      auction_id_list = self.select { |a| a.offers.present? }.pluck(:id)
    when 'without_offers'
      auction_id_list = self.select { |a| a.offers.empty? }.pluck(:id)
    end

    self.where(id: auction_id_list)
  end

  delegate :count, to: :offers, prefix: true
  delegate :size, to: :offers, prefix: true

  def update_list_broadcast
    Auctions::UpdateListBroadcastService.call({ auction: self })
  end

  def update_offer_broadcast
    Auctions::UpdateOfferBroadcastService.call({ auction: self })
  end

  def deposit
    Money.new(requirement_deposit_in_cents, Setting.find_by(code: 'auction_currency').retrieve)
  end

  def deposit=(value)
    number = value.to_d
    deposit = Money.from_amount(number, Setting.find_by(code: 'auction_currency').retrieve)
    self.requirement_deposit_in_cents = deposit.cents
  end

  def self.search(params = {})
    sort_column = params[:sort].presence_in(%w[domain_name starts_at ends_at platform users_price]) || 'domain_name'
    sort_admin_column = params[:sort].presence_in(%w[domain name
                                                     starts_at
                                                     ends_at
                                                     highest_offer_cents
                                                     number_of_offers
                                                     turns_count
                                                     starting_price
                                                     min_bids_step
                                                     slipping_end
                                                     platform]) || 'id'
    sort_direction = params[:direction].presence_in(%w[asc desc]) || 'desc'
    is_from_admin = params[:admin] == 'true'

    self.with_highest_offers
        .with_domain_name(params[:domain_name])
        .with_type(params[:type])
        .with_starts_at(params[:starts_at])
        .with_ends_at(params[:ends_at])
        .with_starts_at_nil(params[:starts_at_nil])
        .with_offers(params[:auction_offer_type], params[:type])
        .order("#{is_from_admin ? sort_admin_column : sort_column} #{sort_direction} NULLS LAST")
  end

  def deposit_and_enable_deposit_should_be_togeter
    return unless english?
    return if (requirement_deposit_in_cents.nil? || requirement_deposit_in_cents.zero?) && !enable_deposit
    return if enable_deposit && requirement_deposit_in_cents && requirement_deposit_in_cents.positive?

    errors.add(:base, 'the deposit amount and the "enable deposit" flag must be specified together or not')
  end

  def enable_deposit_only_for_english_auction
    return if english? || !enable_deposit

    errors.add(:enable_deposit, 'could not be applied for non english auction')
  end

  def allow_to_set_bid?(user)
    return true unless english?
    return true unless enable_deposit?
    return false if user.nil?

    user.domain_participate_auctions.any? { |item| item.auction_id == self.id }
  end

  def does_not_overlap
    return unless starts_at && ends_at
    return unless overlaping_auctions&.exists?

    errors.add(:starts_at, 'overlaps with another auction')
    errors.add(:ends_at, 'overlaps with another auction')
  end

  def starts_at_cannot_be_in_the_past
    return if skip_validation
    return unless starts_at
    return if starts_at >= Time.now.utc

    errors.add(:starts_at, 'cannot be in the past')
  end

  def highest_price
    return unless offers.any?

    offers.order(cents: :desc).limit(1).first.price
  end

  def update_ends_at(offer)
    difference_time = ends_at - offer.updated_at
    difference_time_more_than_null = difference_time > 0.0
    difference_time_less_than_slipping_time = difference_time < (slipping_end * 60).to_f

    return unless difference_time_more_than_null && difference_time_less_than_slipping_time

    surplus_time = (slipping_end * 60).to_f - difference_time.round(2)
    new_deadline = ends_at + surplus_time.seconds

    self.update(ends_at: new_deadline)
  end

  def update_minimum_bid_step(bid, force: false)
    return unless english?

    return if bid < self.min_bids_step && !force

    update_value = 0.01

    if bid < 1.0
      update_value
    elsif bid >= 1.0 && bid < 10.0
      update_value *= 10
    elsif bid >= 10.0 && bid < 100.0
      update_value *= 100
    elsif bid >= 100.0 && bid < 1_000.0
      update_value *= 1_000
    elsif bid >= 1_000.0 && bid < 10_000.0
      update_value *= 10_000
    elsif bid >= 10_000.0 && bid < 100_000.0
      update_value *= 100_000
    end

    self.min_bids_step = (bid + update_value).round(2)
    save!
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
    offers.where('user_id IS NOT NULL').order(cents: :desc, created_at: :asc).first
  end

  def current_price_from_user(user_id)
    offers_query = offers.where(user_id: user_id)
    offers_query.order(cents: :desc).first&.price
  end

  def offer_from_user(user_id)
    offers.where(user_id: user_id).order(cents: :desc).first
  end

  def ends_at_later_than_starts_at
    return if skip_validation
    return unless starts_at && ends_at
    return if ends_at > starts_at

    errors.add(:starts_at, 'must be earlier than ends_at')
  end

  def overlaping_auctions
    dates_order = [starts_at, ends_at].sort
    sql = "domain_name = ? AND tsrange(starts_at, ends_at, '[]') && tsrange(?, ?, '[]')"
    auctions = Auction.unscoped.where(sql, domain_name, dates_order.first, dates_order.second)
    auctions = auctions.where.not(id: id) if persisted?
    auctions
  end

  def can_be_deleted?
    return true if starts_at.nil?

    if valid?
      (!in_progress? || offers.blank?) && !finished?
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
    return false if starts_at.nil?

    if valid?
      Time.now.utc > starts_at && !finished?
    else
      false
    end
  end

  def find_auction_turns
    update(turns_count: calculate_turns_count)
  end

  def calculate_turns_count
    auctions = Auction.unscoped.where(domain_name: domain_name).where('starts_at <= ?', starts_at)
    result_statuses = auctions.order(:ends_at).map { |auction| auction.result&.status }
    return 1 unless result_statuses.present? && result_statuses.first.present?

    calculate_count(result_statuses)
  end

  def calculate_count(result_statuses)
    statuses_to_drop_count = [::Result.statuses[:domain_registered],
                              ::Result.statuses[:no_bids]]
    result_statuses = result_statuses.take(result_statuses.size - 1).insert(0, nil)
    result_statuses.reduce(0) do |sum, status|
      statuses_to_drop_count.include?(status) ? 1 : sum + 1
    end
  end

  def users_price
    Money.new(users_offer_cents, Setting.find_by(code: 'auction_currency').retrieve)
  end

  def maximum_bids
    Money.new(offers.maximum(:cents), Setting.find_by(code: 'auction_currency').retrieve)
  end

  def self.with_user_offers(user_id)
    Auction.from(with_user_offers_query(user_id))
  end

  def self.with_user_offers_query(user_id)
    sql = <<~SQL
      (WITH offers_subquery AS (
          SELECT *
          FROM offers
          WHERE user_id = ?
      )
      SELECT DISTINCT
          auctions.*,
          offers_subquery.cents AS users_offer_cents,
          offers_subquery.id AS users_offer_id,
          offers_subquery.uuid AS users_offer_uuid
      FROM auctions
      LEFT JOIN offers_subquery on auctions.id = offers_subquery.auction_id) AS auctions
    SQL

    ActiveRecord::Base.sanitize_sql([sql, user_id])
  end

  def self.with_highest_offers
    Auction.from(with_highest_offers_query)
  end

  def self.with_highest_offers_query
    sql = <<~SQL
      (WITH offers_subquery AS (
          SELECT DISTINCT on (uuid) offers.*
          FROM (SELECT auction_id,
               max(cents) over (PARTITION BY auction_id)             as max_price,
               min(created_at) over (PARTITION BY auction_id, cents) as min_time
               FROM offers
       ) AS highest_offers
       INNER JOIN offers
       ON
          offers.cents = highest_offers.max_price AND
          offers.created_at = highest_offers.min_time AND
          offers.auction_id = highest_offers.auction_id)
      SELECT DISTINCT
          auctions.*,
          offers_subquery.cents AS highest_offer_cents,
          offers_subquery.id AS highest_offer_id,
          offers_subquery.uuid AS highest_offer_uuid,
          (SELECT COUNT(*) FROM offers where offers.auction_id = auctions.id) AS number_of_offers
      FROM auctions
      LEFT JOIN offers_subquery on auctions.id = offers_subquery.auction_id) AS auctions
    SQL

    sql
  end
end
