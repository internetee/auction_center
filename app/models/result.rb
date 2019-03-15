require 'auction_not_finished'
require 'auction_not_found'

class Result < ApplicationRecord
  enum status: { no_bids: 'no_bids',
                 awaiting_payment: 'awaiting_payment',
                 payment_received: 'payment_received',
                 payment_not_received: 'payment_not_received',
                 domain_registered: 'domain_registered',
                 domain_not_registered: 'domain_not_registered' }

  belongs_to :auction, optional: false, inverse_of: :result
  belongs_to :user, optional: true
  belongs_to :offer, optional: true
  has_one :invoice, required: false, dependent: :destroy

  scope :pending_invoice, lambda {
    where('user_id IS NOT NULL AND status = ? AND id NOT IN (SELECT result_id FROM invoices)',
          statuses[:awaiting_payment])
  }

  scope :pending_status_report, lambda {
    where('status <> last_remote_status OR last_remote_status IS NULL')
  }

  scope :pending_registration, lambda {
    where('status = ?', statuses[:payment_received])
  }

  scope :pending_registration_reminder, lambda {
    where(status: Result.statuses[:payment_received])
      .where('registration_due_date <= ?',
             Time.zone.today + Setting.domain_registration_reminder_day)
      .where('registration_reminder_sent_at IS NULL')
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

  def mark_as_payment_received(time)
    date = time.to_date + Setting.registration_term
    update!(status: Result.statuses[:payment_received],
            registration_due_date: date)
  end

  def send_email_to_winner
    return unless awaiting_payment?

    ResultMailer.winner_email(self).deliver_later
  end
end
