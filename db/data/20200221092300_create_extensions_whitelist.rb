class CreateExtensionsWhitelist < ActiveRecord::Migration[6.0]
  def up
    domain_extensions_description = <<~TEXT.squish
      Supported domain extensions for wishlist domain monitoring.
    TEXT
    extensions = ['ee', 'pri.ee', 'com.ee', 'med.ee', 'fie.ee']

    setting = Setting.find_or_create_by(code: :wishlist_supported_domain_extensions)
    return if setting.value.present?

    setting.update!(value: extensions,
                    description: domain_extensions_description,
                    value_format: 'array')
  end

  def down
  end
end
