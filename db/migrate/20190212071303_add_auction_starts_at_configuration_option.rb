class AddAuctionStartsAtConfigurationOption < ActiveRecord::Migration[5.2]
  def up
    auctions_start_at_description = <<~TEXT.squish
      Whole hour at which auctions should start. Allowed values are anything between 0 and 23 or
      'false'. In case 'false' is used, auctions are started as soon as possible.
    TEXT

    auctions_start_at_setting = Setting.new(code: :auctions_start_at, value: '0',
                                   description: auctions_start_at_description)

    auctions_start_at_setting.save
  end

  def down
    Setting.where(code: :auctions_start_at).delete_all
  end
end
