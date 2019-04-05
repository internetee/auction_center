module Errors
  class NoCancelledInvoices < StandardError
    attr_reader :user_id, :domain_name, :message

    def initialize(user_id, domain_name)
      @user_id = user_id
      @domain_name = domain_name
      @message = <<~TEXT.squish
        Attempted to create automatic ban for User with id #{user_id} and
        domain_name #{domain_name}. User does not have any overdue invoices.
      TEXT

      super(message)
    end
  end
end
