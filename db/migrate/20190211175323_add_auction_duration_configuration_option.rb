class AddAuctionDurationConfigurationOption < ActiveRecord::Migration[5.2]
  def up
    auction_duration_description = <<~TEXT.squish
      Number of hours for which an auction is created. Default: 24
    TEXT

    auction_duration_setting = Setting.new(code: :auction_duration, value: '24',
                                   description: auction_duration_description)

    auction_duration_setting.save
  end

  def down
    Setting.where(code: :auction_duration).delete_all
  end
end
