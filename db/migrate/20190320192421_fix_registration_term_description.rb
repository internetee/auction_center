class FixRegistrationTermDescription < ActiveRecord::Migration[5.2]
  def up
    setting = Setting.find_by(code: :registration_term)
    return unless setting

    text = <<~TEXT.squish
      Number of days before the auctioned domain must be registered, starting from release of
      registration code. Default: 14
    TEXT

    setting.update!(description: text)
  end

  def down
    setting = Setting.find_by(code: :registration_term)
    return unless setting

    text = <<~TEXT.squish
      Number of days before the auctioned domain must be registered, starting from
      the auction start. Default: 14
    TEXT

    setting.update!(description: text)
  end
end
