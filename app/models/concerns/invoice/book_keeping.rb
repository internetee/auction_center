module Concerns
  module Invoice
    module BookKeeping
      extend ActiveSupport::Concern

      def as_directo_json
        invoice = ActiveSupport::JSON.decode(ActiveSupport::JSON.encode(self))
        invoice = compose_invoice_meta(invoice)
        invoice['invoice_lines'] = compose_directo_product
        invoice['customer'] = compose_directo_customer

        invoice
      end

      def compose_invoice_meta(invoice)
        invoice['issue_date'] = issue_date.strftime('%Y-%m-%d')
        invoice['transaction_date'] = paid_at.strftime('%Y-%m-%d')
        invoice['language'] = user.locale == 'en' ? 'ENG' : ''
        invoice['currency'] = Setting.find_by(code: 'auction_currency').retrieve
        invoice['total_wo_vat'] = price.amount
        invoice['vat_amount'] = vat.amount

        invoice
      end

      def compose_directo_customer
        {
          'name': recipient,
          'code': DirectoCustomer.find_or_create_by(
            vat_number: vat_code
          ).customer_code
        }.as_json
      end

      def compose_directo_product
        [{ 'product_id': 'OKSJON',
           'description': result.auction.domain_name,
           'quantity': 1,
           'unit': 1,
           'price': ActionController::Base.helpers.number_with_precision(
             price.amount, precision: 2, separator: '.'
           ),
           'vat_number': '10' }].as_json
      end
    end
  end
end
