require 'audit_migration'

class AuditApplicationSettingFormats < ActiveRecord::Migration[5.2]
  def up
    migration = AuditMigration.new('application_setting_format')
    execute(migration.create_application_setting_format_table)
    execute(migration.create_application_setting_format_trigger)
  end

  def down
    migration = AuditMigration.new('application_setting_format')
    execute(migration.drop)
  end
end
