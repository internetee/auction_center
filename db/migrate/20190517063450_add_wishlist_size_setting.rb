class AddWishlistSizeSetting < ActiveRecord::Migration[5.2]
  def up
    wishlist_size_description = <<~TEXT.squish
      Number of domains a single user can keep in their wishlist. Default: 10
    TEXT

    wishlist_size_setting = Setting.new(code: :wishlist_size, value: '10',
                                           description: wishlist_size_description)
    wishlist_size_setting.save
  end

  def down
    Setting.find_by(code: :wishlist_size).delete
  end
end
