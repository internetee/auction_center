require 'ostruct'

module EisBilling
  module BaseService
    def struct_response(response)
      if response['error'].present?
        increment_failure_counter(error_type: 'provider_error')
        wrap(result: false, instance: nil, errors: response['error'])
      else
        wrap(result: true, instance: response, errors: nil)
      end
    rescue StandardError => e
      increment_failure_counter(error_type: 'exception', exception_class: e.class.name)
      wrap(result: false, instance: nil, errors: e)
    end

    private

    def increment_failure_counter(error_type:, exception_class: nil)
      Yabeda.eis_billing.payment_failures_total.increment(
        service: self.class.name.demodulize,
        error_type: error_type,
        exception_class: exception_class || 'none'
      )
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
