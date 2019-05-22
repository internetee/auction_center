class WishlistItem < ApplicationRecord
  belongs_to :user, optional: false

  validates :domain_name, uniqueness: { scope: :user_id }
  validates :domain_name,
            presence: true,
            allow_blank: false,
            format: {
              # allows 1 to 61 characters with Estonian diacritic signs and 1 to 61 character
              # of the top level domain.
              with: /\A[a-z0-9\-\u00E4\u00F5\u00F6\u00FC\u0161\u017E]{1,61}\.[a-z0-9]{1,61}\z/,
            }

  validate :must_fit_in_wishlist_size, on: :create

  scope :for_user, ->(user_id) { where(user_id: user_id) }

  # A user can only have limited number to discourage people from putting the whole zone into
  # the wishlist.
  def must_fit_in_wishlist_size
    return if number_of_items_for_user < Setting.wishlist_size

    errors.add(:wishlist, I18n.t('wishlist_items.too_many_items'))
  end

  # Can safely return zero if user_id is unset, without it the whole object is invalid.
  def number_of_items_for_user
    if user_id
      WishlistItem.for_user(user_id).count
    else
      0
    end
  end
end
