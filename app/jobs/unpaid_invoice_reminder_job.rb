class UnpaidInvoiceReminderJob < ApplicationJob
  def perform
    Invoice.pending_payment_reminder.each do |invoice|
      InvoiceMailer.reminder_email(invoice).deliver_later
    end
  end

  def self.needs_to_run?
    Invoice.pending_payment_reminder.any?
  end
end
