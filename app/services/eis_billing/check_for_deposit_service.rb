module EisBilling
  class CheckForDepositService
    include EisBilling::Request

    INITIATOR = 'auction'.freeze

    attr_reader :domain_name, :user_uuid, :user_email, :transaction_amount, :invoice_number

    def initialize(domain_name:, user_uuid:, user_email:, transaction_amount:, invoice_number:)
      @domain_name = domain_name
      @user_uuid = user_uuid
      @user_email = user_email
      @transaction_amount = transaction_amount
      @invoice_number = invoice_number
    end

    def self.call(domain_name:, user_uuid:, user_email:, transaction_amount:, invoice_number:)
      new(domain_name: domain_name,
          user_uuid: user_uuid,
          user_email: user_email,
          transaction_amount: transaction_amount,
          invoice_number: invoice_number).call
    end

    def call
      set_available_for_user
    end

    private

    def set_available_for_user
      auction = Auction.where(domain_name: domain_name).order(created_at: :desc).first

      return false unless auction.enable_deposit?
      return false unless auction.deposit.to_f <= transaction_amount.to_f

      user = User.find_by_uuid(user_uuid)
      DomainParticipateAuction.create!(user: user, auction: auction, invoice_number: invoice_number)
    end
  end
end
