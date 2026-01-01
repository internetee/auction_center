module Pages
  module Invoices
    module OutstandingInvoices
      class Component < ApplicationViewComponent
        attr_reader :issued_invoices, :cancelled_payable_invoices, :cancelled_expired_invoices,
                     :unpaid_invoices_count, :pagy_issued, :pagy_cancelled_payable, :pagy_cancelled_expired

        def initialize(issued_invoices:, cancelled_payable_invoices:, cancelled_expired_invoices:,
                       unpaid_invoices_count:, pagy_issued:, pagy_cancelled_payable:, pagy_cancelled_expired:)
          super()

          @issued_invoices = issued_invoices
          @cancelled_payable_invoices = cancelled_payable_invoices
          @cancelled_expired_invoices = cancelled_expired_invoices
          @unpaid_invoices_count = unpaid_invoices_count
          @pagy_issued = pagy_issued
          @pagy_cancelled_payable = pagy_cancelled_payable
          @pagy_cancelled_expired = pagy_cancelled_expired
        end

        def issued_invoice_table_headers
          # NB! if you want make columns as sortable, don't forget to wrap the table content within the turbo_frame_tag
          # with the name "results". The name "results" is assigned as a value for the orderable Stimulus controller 
          # in the table component.
          [{ column: nil, caption: t('invoices.item'), options: { class: '' } },
           { column: nil, caption: t('invoices.due_date'), options: { class: '' } },
           { column: nil, caption: t('invoices.total'), options: { class: '' } },
           { column: nil, caption: t('actions_name'),
             options: { class: 'u-text-center-l' } }]
        end

        def overdue_invoice_table_headers
          [{ column: nil, caption: t('invoices.item'), options: { class: '' } },
           { column: nil, caption: t('invoices.due_date'), options: { class: '' } },
           { column: nil, caption: t('invoices.total'), options: { class: '' } },
           { column: nil, caption: t('actions_name'),
             options: { class: 'u-text-center-l' } }]
        end

        def cancel_invoice_table_headers
          [{ column: nil, caption: t('invoices.item'), options: { class: '' } },
           { column: nil, caption: t('invoices.due_date'), options: { class: '' } },
           { column: nil, caption: t('invoices.total'), options: { class: '' } },
           { column: nil, caption: t('actions_name'),
             options: { class: 'u-text-center-l' } }]
        end
      end
    end
  end
end
