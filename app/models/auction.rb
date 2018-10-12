class Auction < ApplicationRecord
  validates :domain_name, presence: true
  validates :ends_at, presence: true

  scope :active, -> { where('ends_at >= ?', Time.now.utc) }

  def finished?
    Time.now.utc >= ends_at
  end
end
