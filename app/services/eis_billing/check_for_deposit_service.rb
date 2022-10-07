module EisBilling
  class CheckForDepositService
    include EisBilling::Request

    INITIATOR = 'auction'.freeze

    attr_reader :auction_name, :user_uuid

    def initialize(auction_name:, user_uuid:)
      @auction_name = auction_name
      @user_uuid = user_uuid
    end

    def self.call(auction_name:, user_uuid:)
      service = new(auction_name: auction_name, user_uuid: user_uuid)
    end
  end
end
