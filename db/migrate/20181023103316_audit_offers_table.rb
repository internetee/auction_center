require 'audit_migration'

class AuditOffersTable < ActiveRecord::Migration[5.2]
  def up
    migration = AuditMigration.new('offer')
    execute(migration.create_table)
    execute(migration.create_trigger)
  end

  def down
    migration = AuditMigration.new('offer')
    execute(migration.drop)
  end
end
