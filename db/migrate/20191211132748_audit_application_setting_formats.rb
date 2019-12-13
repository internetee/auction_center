require 'audit_migration'

class AuditApplicationSettingFormats < ActiveRecord::Migration[5.2]
  def up
    migration = AuditMigration.new('application_setting_format')
    execute(migration.create_dynamic_table)
    execute(migration.create_trigger)
  end

  def down
    migration = AuditMigration.new('application_setting_format')
    execute(migration.drop)
  end
end
