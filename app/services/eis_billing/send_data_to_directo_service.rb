module EisBilling
  class SendDataToDirectoService
    include EisBilling::Request

    attr_reader :object_data

    def initialize(object_data:)
      @object_data = object_data
    end

    def self.call(object_data:)
      new(object_data: object_data).call
    end

    def call
      send_info
    end

    private

    def send_info
      prepared_data = {
        invoice_data: object_data,
        initiator: INITIATOR,
      }

      post directo_url, prepared_data
    end

    def directo_url
      '/api/v1/directo/directo'
    end
  end
end
