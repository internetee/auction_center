class Result < ApplicationRecord
  belongs_to :auction, -> { where(ends_at < Time.now.utc) }, required: true, inverse_of: :result
  belongs_to :user, required: false

  validates :sold, presence: true
end
