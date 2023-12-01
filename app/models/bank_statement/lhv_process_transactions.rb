# frozen_string_literal: true

module BankStatement::LHVProcessTransactions
  extend ActiveSupport::Concern

  def process_lhv_transaction(incoming_transaction)
    ActiveRecord::Base.transaction do
      transaction = bank_transactions.create!(transaction_attributes(incoming_transaction))

      if transaction.user.blank?
        inform_admin(incoming_transaction)

        next
      end

      approve_payments(transaction)
    end
  end

  private

  def approve_payments(transaction)
    inform_admin(transaction) unless transaction.autobind_invoice
  end

  def inform_admin(incoming_transaction)
    AdminMailer.transaction_mail(incoming_transaction.to_s).deliver_later
  end

  def transaction_attributes(incoming_transaction)
    {
      sum: incoming_transaction['amount'],
      currency: incoming_transaction['currency'],
      paid_at: incoming_transaction['date'],
      reference_no: incoming_transaction['payment_reference_number'],
      description: incoming_transaction['payment_description']
    }
  end
end
