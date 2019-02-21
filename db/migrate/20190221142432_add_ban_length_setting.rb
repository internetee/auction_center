class AddBanLengthSetting < ActiveRecord::Migration[5.2]
  def change
    ban_length_description = <<~TEXT.squish
      Number of months for which a repeated offender is banned for. Default: 100
    TEXT

    ban_length_setting = Setting.new(code: :ban_length, value: '100',
                                   description: ban_length_description)

    ban_length_setting.save
  end

  def down
    Setting.where(code: :ban_length).delete_all
  end
end
