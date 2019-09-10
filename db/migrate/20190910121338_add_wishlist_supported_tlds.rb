class AddWishlistSupportedTlds < ActiveRecord::Migration[5.2]
  def up
    wishlist_supported_tld_description = <<~TEXT.squish
      Supported TLD's for wishlist domain monitoring. First entry is used as a default autocomplete value. Separate with "|" (pipe) 
    TEXT

    wishlist_supported_tld_setting = Setting.new(code: :wishlist_supported_tld, value: 'ee|pri.ee|com.ee|med.ee|fie.ee',
                                        description: wishlist_supported_tld_description)
    wishlist_supported_tld_setting.save
  end

  def down
    Setting.find_by(code: :wishlist_supported_tld).delete
  end
end
