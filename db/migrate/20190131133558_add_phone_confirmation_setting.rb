class AddPhoneConfirmationSetting < ActiveRecord::Migration[5.2]
  def up
    phone_confirmation_description = <<~TEXT.squish
      Require mobile numbers to be confirmed by SMS before user can place offers. Can be either 'true'
      or 'false'
    TEXT

    phone_confirmation_setting = Setting.new(code: :require_phone_confirmation,
                                             value: 'false',
                                             description: phone_confirmation_description)

    phone_confirmation_setting.save
  end

  def down
    Setting.where(code: :require_phone_confirmation).delete_all
  end
end
