# frozen_string_literal: true

# Yabeda business metrics for invoices and payments
# Tracks invoice creation, payments, overdue invoices, and payment flow failures

Yabeda.configure do
  group :invoice_business do
    counter :invoices_created_total,
      comment: "Total created invoices",
      tags: %i[status]

    counter :invoices_paid_total,
      comment: "Total fully paid invoices",
      tags: %i[payment_channel]

    gauge :invoices_overdue_total,
      comment: "Number of overdue invoices"

    counter :payment_flow_failures_total,
      comment: "Payment flow errors",
      tags: %i[flow error_type]
  end
end
