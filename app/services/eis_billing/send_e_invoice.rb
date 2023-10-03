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
      prepared_data = build_prepared_data
      struct_response(post(e_invoice_url, prepared_data))
    end

    private

    def build_prepared_data
      {
        invoice: invoice.e_invoice_data,
        vat_amount: invoice.vat.to_f,
        invoice_subtotal: invoice.price.to_f,
        buyer_billing_email: invoice.user&.email,
        payable: payable,
        inbound: prepare_inbound_data(invoice),
        initiator: INITIATOR,
        items: prepare_items(invoice),
      }
    end

    def prepare_items(invoice)
      invoice.items.map do |invoice_item|
        {
          description: invoice_item.name,
          price: invoice_item.price.to_f,
          quantity: 1,
          unit: 'piece',
          subtotal: invoice_item.price.to_f,
          vat_rate: invoice.vat_rate.to_f * 100,
          vat_amount: invoice_item.price.to_f * invoice.vat_rate,
          total: invoice_item.price.to_f * (1 + invoice.vat_rate),
        }
      end
    end

    def prepare_inbound_data(invoice)
      total = invoice.price.to_f * (1 + invoice.vat_rate)
      return total if payable == false

      invoice.enable_deposit? ? invoice.deposit.to_f : 0
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
