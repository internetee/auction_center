require 'audit_migration'

class AuditBansTable < ActiveRecord::Migration[5.2]
  def up
    migration = AuditMigration.new('ban')
    execute(migration.create_table)
    execute(migration.create_trigger)
  end

  def down
    migration = AuditMigration.new('ban')
    execute(migration.drop)
  end
end
