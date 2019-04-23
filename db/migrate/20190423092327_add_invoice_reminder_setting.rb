class AddInvoiceReminderSetting < ActiveRecord::Migration[5.2]
  def up
    invoice_reminder_description = <<~TEXT.squish
      Number of days before due date on which reminders about unpaid invoices are sent.
      Use 0 to send reminders on due date. Default: 3
    TEXT

    invoice_reminder_setting = Setting.new(code: :invoice_reminder_in_days, value: '3',
                                           description: invoice_reminder_description)

    invoice_reminder_setting.save
  end

  def down
    Setting.find_by(code: :invoice_reminder_in_days).delete
  end
end
