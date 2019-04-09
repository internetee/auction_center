class FixPaymentTermSettingDescription < ActiveRecord::Migration[5.2]
  def up
    setting = Setting.find_by(code: :payment_term)
    return unless setting

    text = <<~TEXT.squish
      Number of full days after the issue date the recipient has time to pay for the invoice.
      If invoices are generated at the start of a day you might want to substract 1 from the
      setting to achieve desired invoice due date. Default: 7
    TEXT

    setting.update!(description: text)
  end

  def down
    setting = Setting.find_by(code: :payment_term)
    return unless setting

    text = <<~TEXT.squish
      Number of days before which an invoice for auction must be paid. Default: 7
    TEXT

    setting.update!(description: text)
  end
end
