class CreateApplicationSettingFormats < ActiveRecord::Migration[5.2]
  def change
    create_table :application_setting_formats do |t|
      t.string :data_type, null: false
      t.jsonb :settings, null: false, default: {}

      t.timestamps
    end
  end
end
