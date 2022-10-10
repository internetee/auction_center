module EisBilling
  class CheckForDepositService
    include EisBilling::Request

    INITIATOR = 'auction'.freeze

    attr_reader :domain_name, :user_uuid, :user_email, :transaction_amount

    def initialize(domain_name:, user_uuid:, user_email:, transaction_amount:)
      @domain_name = domain_name
      @user_uuid = user_uuid
      @user_email = user_email
      @transaction_amount = transaction_amount
    end

    def self.call(domain_name:, user_uuid:, user_email:, transaction_amount:)
      service = new(domain_name: domain_name,
                    user_uuid: user_uuid,
                    user_email: user_email,
                    transaction_amount: transaction_amount)
      service.set_available_for_user
    end

    def set_available_for_user
      auction = Auction.find_by_domain_name(domain_name)

      return false unless auction.enable_deposit?
      return false unless auction.deposit.to_f <= transaction_amount.to_f

      user = User.find_by_uuid(user_uuid)
      DomainParticipateAuction.create!(user: user, auction: auction)
    end
  end
end
