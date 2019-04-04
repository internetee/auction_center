class Ban < ApplicationRecord
  belongs_to :user, optional: true
  validates :valid_until, presence: true
  validate :valid_until_later_valid_from

  def valid_until_later_valid_from
    return unless valid_until
    return if valid_until > (valid_from || Time.zone.now)

    errors.add(:valid_until, 'must be later than valid_from')
  end

  scope :valid, lambda {
    where('valid_until >= ? AND valid_from <= ?', Time.now.utc, Time.now.utc)
  }
end
