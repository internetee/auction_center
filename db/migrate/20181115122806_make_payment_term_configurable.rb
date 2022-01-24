class MakePaymentTermConfigurable < ActiveRecord::Migration[5.2]
  # def up
  #   payment_term_description = <<~TEXT.squish
  #     Number of days before which an invoice for auction must be paid. Default: 7
  #   TEXT
  #
  #   payment_term_setting = Setting.new(code: :payment_term, value: '7',
  #                                  description: payment_term_description)
  #
  #   payment_term_setting.save
  # end
  #
  # def down
  #   Setting.where(code: :payment_term).delete_all
  # end
end
