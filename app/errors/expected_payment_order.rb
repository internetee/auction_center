module Errors
  class ExpectedPaymentOrder < StandardError
    attr_reader :provided_class, :message

    def initialize(provided_class = nil)
      @provided_class = provided_class.name
      @message = "Expected #{provided_class} to be a descendant of PaymentOrder."
      super(message)
    end
  end
end
