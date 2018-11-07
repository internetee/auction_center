class Result < ApplicationRecord
  belongs_to :auction, required: true
  belongs_to :user, required: false

  validates :sold, presence: true
end
