class InvoicePaymentOrder < ApplicationRecord
  belongs_to :invoice
  belongs_to :payment_order
end
