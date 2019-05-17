class WishlistItem < ApplicationRecord
  belongs_to :user, optional: false
  validates :domain_name, presence: true, allow_blank: false
  validates :valid_until, presence: true
end
