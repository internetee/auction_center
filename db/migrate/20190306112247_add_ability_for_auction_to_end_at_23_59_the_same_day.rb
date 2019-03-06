class AddAbilityForAuctionToEndAt2359TheSameDay < ActiveRecord::Migration[5.2]
  def up
    auction_duration_description = <<~TEXT.squish
      Number of hours for which an auction is created. You can also use 'end_of_day'
      for auctions to end at the end of the same calendar day. Default: 24.
    TEXT

    setting = Setting.find_by(code: :auction_duration)

    setting.update!(description: auction_duration_description)
  end

  def down
    auction_duration_description = <<~TEXT.squish
      Number of hours for which an auction is created. Default: 24
    TEXT

    setting = Setting.find_by(code: :auction_duration)
    setting.update!(description: auction_duration_description)
  end
end
