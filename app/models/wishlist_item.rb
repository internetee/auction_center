class WishlistItem < ApplicationRecord
  belongs_to :user, optional: false
  validates :domain_name,
            presence: true,
            allow_blank: false,
            format: {
            # allows 1 to 61 characters with Estonian diacritic signs and 1 to 61 character
            # of the top level domain.
              with: /[a-z0-9\-\u00E4\u00F5\u00F6\u00FC\u0161\u017E]{1,61}\.[a-z0-9]{1,61}/,
            }
  validate :must_fit_in_wishlist_size

  # A user can only have limited number to discourage people from putting the whole zone into
  # the wishlist.
  def must_fit_in_wishlist_size; end
end
