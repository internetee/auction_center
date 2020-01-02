class AddValueFormatToSetting < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :value_format, :string, null: false, default: "string"
  end
end
