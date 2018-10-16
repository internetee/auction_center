class Auction < ApplicationRecord
  validates :domain_name, presence: true
  validates :ends_at, presence: true

  # validate :must_not_overlap, on: :create

  scope :active, -> { where('ends_at >= ?', Time.now.utc) }
  scope :overlapping, lambda { |auction|
    sql = <<~SQL.squish
             domain_name = ? AND
             tsrange(starts_at, ends_at, '[]') && tsrange(?, ?, '[]')
          SQL

    where(sql,auction.domain_name, auction.starts_at, auction.ends_at)
  }

  def must_not_overlap
    if Auction.overlapping(self).exists?
      errors.add(:starts_at, 'overlaps with another auction')
      errors.add(:ends_at, 'overlaps with another auction')
    end
  end

  def finished?
    Time.now.utc >= ends_at
  end
end
