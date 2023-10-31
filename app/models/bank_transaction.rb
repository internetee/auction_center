class BankTransaction < ApplicationRecord
  MULTI_REGEXP = /(\d{2,20})/

  belongs_to :bank_statement

  scope :unbinded, lambda {
    where('id NOT IN (SELECT bank_transaction_id FROM account_activities where bank_transaction_id IS NOT NULL)')
  }

  def user
    @user ||= User.find_by(reference_no: parsed_ref_number)
  end

  def parsed_ref_number
    reference_no || ref_number_from_description
  end

  def ref_number_from_description
    matches = description.to_s.scan(MULTI_REGEXP).flatten
    matches.detect { |m| break m if m.length == 7 || valid_ref_no?(m) }
  end

  def invoice
    return unless user

    @invoice ||= user.invoices.order(created_at: :asc).issued.where.not(status: :canceled).find_by(total: sum)
  end

  def autobind_invoice
    return if invoice.nil?

    payment_order = PaymentOrder.find_by(invoice_id: invoice.id) ||
                    PaymentOrders::EveryPay.create(invoices: [invoice], user: invoice.user)

    payment_order.save
    payment_order.mark_invoice_as_paid

    invoice
  end
end
