require 'simpleidn'

class WishlistItem < ApplicationRecord
  belongs_to :user, optional: false

  before_validation :set_domain_name_to_unicode

  validates :domain_name, uniqueness: { scope: :user_id }

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
    return if number_of_items_for_user < ApplicationSetting.wishlist_size

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
    if user_id
      WishlistItem.for_user(user_id).count
    else
      0
    end
  end

  private

  # Validate that FQDN has supported extension
  def valid_domain_extension
    return if ApplicationSetting.wishlist_supported_domain_extensions.empty?
    return if ApplicationSetting.wishlist_supported_domain_extensions.include?(domain_name.split('.', 2).last)

    errors.add(:domain_name, :invalid) if errors[:domain_name].blank?
  end
end
