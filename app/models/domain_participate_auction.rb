class DomainParticipateAuction < ApplicationRecord
  belongs_to :user
  belongs_to :auction

  enum status: ['paid', 'prepayment', 'returned']

  scope :search_by_auction_name_and_user_email, ->(origin) {
    if origin.present?
      joins(:user).joins(:auction).where('users.email ILIKE ? OR auctions.domain_name ILIKE ?', "%#{origin}%", "%#{origin}%")
    end
  }

  def self.search(params = {})
    search_by_auction_name_and_user_email(params[:search_string])
  end

  def send_deposit_status_to_billing_system
    EisBilling::DepositStatusService.call(domain_name: auction.domain_name, user_uuid: user.uuid, status: status)
  end
end
