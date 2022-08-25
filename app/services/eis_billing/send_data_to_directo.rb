module EisBilling
  class SendDataToDirecto < EisBilling::Base
    include EisBilling::Request

    def self.send_request(object_data:)
      fetcher = new
      fetcher.send_info(object_data: object_data)
    end

    def send_info(object_data:)
      prepared_data = {
        invoice_data: object_data,
        initiator: INITIATOR,
      }

      # http = EisBilling::Base.base_request(url: directo_url)
      # http.post(directo_url, prepared_data.to_json, EisBilling::Base.headers)
      post directo_url, prepared_data
    end

    def directo_url
      "/api/v1/directo/directo"
    end
  end
end
