require 'simpleidn'

class WishlistItem < ApplicationRecord
  belongs_to :user, optional: false

  before_validation :set_domain_name_to_unicode
  before_validation :autocomplete_domain_extension

  validates :domain_name, uniqueness: { scope: :user_id }
  validates :cents, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  # 1) Allows 1 to 61 characters with Estonian diacritic signs as domain name / third-level domain.
  # 2) 1 to 61 chars with Estonian diacritic signs as second-level domain (optional) and 1 to 61
  # characters as top level domain, which represents domain name extension when concatenated.
  domain_name_regexp = /\A[a-z0-9\-\u00E4\u00F5\u00F6\u00FC\u0161\u017E]{1,61}\.
                       ([a-z0-9\-\u00E4\u00F5\u00F6\u00FC\u0161\u017E]{1,61}\.)?[a-z0-9]{1,61}\z/x

  validates :domain_name,
            presence: true,
            allow_blank: false,
            format: {
              with: domain_name_regexp,
            }

  validate :must_fit_in_wishlist_size, on: :create
  validate :valid_domain_extension, on: :create

  scope :for_user, ->(user_id) { where(user_id: user_id) }

  # A user can only have limited number to discourage people from putting the whole zone into
  # the wishlist.
  def must_fit_in_wishlist_size
    return if number_of_items_for_user < Setting.find_by(code: 'wishlist_size').retrieve

    errors.add(:wishlist, I18n.t('wishlist_items.too_many_items'))
  end

  # The fact that we store domain names as unicode is our own implementation detail and we should
  # accept either form from the user, so this should not be a validation.
  #
  # Duplicates the functionality in written in Javascript, just in case someone has it disabled
  # on their browsers.
  def set_domain_name_to_unicode
    self.domain_name = SimpleIDN.to_unicode(domain_name)
  end

  # Can safely return zero if user_id is unset, without it the whole object is invalid.
  def number_of_items_for_user
    user_id ? WishlistItem.for_user(user_id).count : 0
  end

  def price
    Money.new(cents, Setting.find_by(code: 'auction_currency').retrieve)
  end

  # def maximum_bid
  #   Money.new(highest_bid, Setting.find_by(code: 'auction_currency').retrieve)
  # end

  def price=(value)
    price = Money.from_amount(value.to_d, Setting.find_by(code: 'auction_currency').retrieve)
    self.cents = price.cents.positive? ? price.cents : nil
  end

  # def maximum_bid=(value)
  #   maximum_bid = Money.from_amount(value.to_d, Setting.find_by(code: 'auction_currency').retrieve)
  #   self.highest_bid = maximum_bid.cents.positive? ? maximum_bid.cents : nil
  # end

  private

  # Appends first domain extension in supported extension list in case no extension
  # was defined by customer beforehand.
  def autocomplete_domain_extension
    extensions = Setting.find_by(code: 'wishlist_supported_domain_extensions').retrieve
    return if extensions.empty?

    self.domain_name = "#{domain_name}.#{extensions.first}" unless domain_name.include?('.')
  end

  # Validate that FQDN has supported extension
  def valid_domain_extension
    domain_extension = Setting.find_by(code: 'wishlist_supported_domain_extensions').retrieve
    return if domain_extension.empty? || domain_extension.include?(domain_name.split('.', 2).last)

    errors.add(:domain_name, :invalid) if errors[:domain_name].blank?
  end
end
