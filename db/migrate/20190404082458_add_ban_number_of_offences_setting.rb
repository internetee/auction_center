class AddBanNumberOfOffencesSetting < ActiveRecord::Migration[5.2]
  def up
    ban_number_of_strikes_description = <<~TEXT.squish
      Number of strikes (unpaid invoices) at which a long ban is applied. Default: 3
    TEXT

    ban_number_of_strikes_setting = Setting.new(code: :ban_number_of_strikes, value: '3',
                                              description: ban_number_of_strikes_description)

    ban_number_of_strikes_setting.save
  end

  def down
    Setting.find_by(code: :ban_number_of_strikes).delete
  end
end
