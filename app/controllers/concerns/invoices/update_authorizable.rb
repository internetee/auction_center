module Invoices
  module UpdateAuthorizable
    extend ActiveSupport::Concern

    included do
      before_action :authorize_user
      before_action :authorize_for_update
    end

    private

    def authorize_user
      authorize! :read, Invoice
    end

    def authorize_for_update
      authorize! :update, @invoice
    end
  end
end