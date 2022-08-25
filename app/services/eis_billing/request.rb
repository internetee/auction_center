module EisBilling
  module Request
    include EisBilling::Connection

    def get(path, params = {})
      respond_with(
        connection.get(path, params)
      )
    end

    def post(path, params = {})
      respond_with(
        connection.post(path, JSON.dump(params))
      )
    end

    private

    def respond_with(response)
      p '------- body'
      p response.body
      p '-----------'
      
      JSON.parse response.body
    end
  end
end
