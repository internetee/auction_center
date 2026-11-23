module EisBilling
  class Invoice
    include EisBilling::Request
    include EisBilling::BaseService

    MONTONIO_LOCALES = %w[de en et fi lt lv pl ru].freeze
    DEFAULT_LOCALE = 'en'.freeze

    attr_reader :invoice

    def initialize(invoice:)
      @invoice = invoice
    end

    def self.call(invoice:)
      new(invoice: invoice).call
    end

    def call
      struct_response(send_request)
    end

    private

    def params
      data = {}
      data[:transaction_amount] = invoice.total.to_f
      data[:order_reference] = invoice.number
      data[:customer_name] = "#{invoice.user.given_names} #{invoice.user.surname}"
      data[:customer_email] = invoice.user.email
      data[:custom_field1] = 'prepended'
      data[:custom_field2] = INITIATOR
      data[:invoice_number] = invoice.number
      data[:due_date] = invoice.due_date&.to_date&.iso8601
      data[:locale] = payer_locale
      data[:return_url] = return_url

      data
    end

    def payer_locale
      locale = invoice.user&.locale.to_s.downcase.split(/[-_]/).first
      MONTONIO_LOCALES.include?(locale) ? locale : DEFAULT_LOCALE
    end

    def return_url
      Rails.application.routes.url_helpers
           .montonio_callback_url(**ActionMailer::Base.default_url_options)
    end

    def send_request
      post invoice_generator_url, params
    end

    def invoice_generator_url
      '/api/v1/invoice_generator/invoice_generator'
    end
  end
end
