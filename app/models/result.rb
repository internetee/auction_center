require 'auction_not_finished'
require 'auction_not_found'

class Result < ApplicationRecord
  enum status: { no_bids: 'no_bids',
                 awaiting_payment: 'awaiting_payment',
                 payment_received: 'payment_received',
                 payment_not_received: 'payment_not_received',
                 domain_registered: 'domain_registered',
                 domain_not_registered: 'domain_not_registered' }

  belongs_to :auction, required: true, inverse_of: :result
  belongs_to :user, required: false
  belongs_to :offer, required: false
  has_one :invoice, required: false, dependent: :destroy

  scope :pending_invoice, lambda {
    where('user_id IS NOT NULL AND status = ? AND id NOT IN (SELECT result_id FROM invoices)',
          statuses[:awaiting_payment])
  }

  scope :pending_status_report, lambda {
    where("status <> last_reported_status OR last_reported_status IS NULL")
  }

  def self.create_from_auction(auction_id)
    auction = Auction.find_by(id: auction_id)

    raise(Errors::AuctionNotFound, auction_id) unless auction
    raise(Errors::AuctionNotFinished, auction_id) unless auction.finished?

    ResultCreator.new(auction_id).call
  end

  def winning_offer
    offer
  end

  def send_email_to_winner
    return unless awaiting_payment?

    ResultMailer.winner_email(self).deliver_later
  end
end
