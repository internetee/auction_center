require 'audit_migration'

class AuditAuctionsTable < ActiveRecord::Migration[5.2]
  def up
    migration = AuditMigration.new('auction')
    execute(migration.create_table)
    execute(migration.create_trigger)
  end

  def down
    migration = AuditMigration.new('auction')
    execute(migration.drop)
  end
end
