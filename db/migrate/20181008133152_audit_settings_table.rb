require 'audit_migration'

class AuditSettingsTable < ActiveRecord::Migration[5.2]
  def up
    migration = AuditMigration.new('setting')
    execute(migration.create_table)
    execute(migration.create_trigger)
  end

  def down
    migration = AuditMigration.new('setting')
    execute(migration.drop)
  end
end
