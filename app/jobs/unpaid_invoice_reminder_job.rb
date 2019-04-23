class UnpaidInvoiceReminderJob < ApplicationJob
  def perform
    invoices_pending_reminder = Invoice.where(status: Invoice.statuses[:issued],
                                              due_date: Time.zone.today)

    invoices_pending_reminder.each do |invoice|
      InvoiceMailer.reminder_email(invoice).deliver_later
    end
  end

  def self.needs_to_run?
    Invoice.where(status: Invoice.statuses[:issued],
                  due_date: Time.zone.today).any?
  end
end
