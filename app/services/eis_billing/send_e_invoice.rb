module EisBilling
  class SendEInvoice < ApplicationService
    include EisBilling::Request
    include EisBilling::BaseService

    attr_reader :invoice, :payable

    def initialize(invoice:, payable:)
      @invoice = invoice
      @payable = payable
    end

    def call
      prepared_data = {
        invoice: invoice.e_invoice_data,
        vat_amount: invoice.vat.amount,
        invoice_subtotal: invoice.price.amount,
        buyer_billing_email: invoice.user&.email,
        payable: payable,
        initiator: INITIATOR,
        items: prepare_items(invoice)
      }

      struct_response(post(e_invoice_url, prepared_data))
    end

    private

    def prepare_items(invoice)
      invoice.items.map do |invoice_item|
        {
          description: item_description(invoice.result),
          price: invoice_item.price.amount,
          quantity: 1,
          unit: 'piece',
          subtotal: invoice_item.price.amount,
          vat_rate: invoice.vat_rate.to_f * 100,
          vat_amount: invoice.vat.amount,
          total: invoice.total.to_f,
        }
      end
    end

    def e_invoice_url
      '/api/v1/e_invoice/e_invoice'
    end

    def item_description(result)
      I18n.t('invoice_items.name', domain_name: result.auction.domain_name,
                                   auction_end: result.auction.ends_at.to_date)
    end
  end
end
