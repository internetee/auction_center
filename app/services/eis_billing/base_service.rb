module EisBilling
  module BaseService
    def struct_response(response)
      if response['error'].present?
        wrap(result: false, instance: nil, errors: response['error'])
      else
        wrap(result: true, instance: response, errors: nil)
      end
    rescue StandardError => e
      wrap(result: false, instance: nil, errors: e)
    end

    def wrap(**kwargs)
      result = kwargs[:result]
      instance = kwargs[:instance]
      errors = kwargs[:errors]

      OpenStruct.new(result?: result,
                     instance: instance,
                     errors: errors)
    end
  end
end
