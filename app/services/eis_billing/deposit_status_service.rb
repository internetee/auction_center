module EisBilling
  class DepositStatusService
    include EisBilling::Request
    include EisBilling::BaseService

    attr_reader :user_uuid, :status, :domain_name

    def initialize(user_uuid:, status:, domain_name:)
      @user_uuid = user_uuid
      @status = status
      @domain_name = domain_name
    end

    def self.call(user_uuid:, status:, domain_name:)
      new(user_uuid: user_uuid, status: status, domain_name:).call
    end

    def call
      struct_response(fetch)
    end

    private

    def fetch
      post deposit_status_url, params
    end

    def params
      { user_uuid: user_uuid,
        domain_name: domain_name,
        status: status }
    end

    def deposit_status_url
      '/api/v1/invoice_generator/deposit_status'
    end
  end
end
