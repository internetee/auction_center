class WebpushSubscription < ApplicationRecord
  validates :endpoint, uniqueness: true

  belongs_to :user
end
