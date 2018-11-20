require 'audit_migration'

class AuditResultsTable < ActiveRecord::Migration[5.2]
  def up
    migration = AuditMigration.new('result')
    execute(migration.create_table)
    execute(migration.create_trigger)
  end

  def down
    migration = AuditMigration.new('result')
    execute(migration.drop)
  end
end
