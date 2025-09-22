module Pages
  module Invoices
    module PaidInvoices
      class Component < ApplicationViewComponent
        attr_reader :paid_invoices, :deposit_paid

        def initialize(paid_invoices:, deposit_paid:)
          super()

          @paid_invoices = paid_invoices
          @deposit_paid = deposit_paid
        end

        def paid_invoices_headers
          [{ column: nil, caption: t('invoices.item'), options: { class: '' } },
           { column: nil, caption: t('invoices.due_date'), options: { class: '' } },
           { column: nil, caption: t('invoices.total'), options: { class: '' } },
           { column: nil, caption: t('actions_name'), options: { class: 'u-text-center-l' } }]
        end

        def deposit_paid_headers
          [{ column: nil, caption: t('invoices.paid_deposit.date'), options: { class: '' } },
           { column: nil, caption: t('invoices.paid_deposit.sum'), options: { class: '' } },
           { column: nil, caption: t('invoices.paid_deposit.auction_name'), options: { class: '' } },
           { column: nil, caption: t('invoices.paid_deposit.status'), options: { class: '' } },
           { column: nil, caption: t('invoices.paid_deposit.refund_time'), options: { class: '' } }]
        end
      end
    end
  end
end
