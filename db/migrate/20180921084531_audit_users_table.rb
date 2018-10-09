require 'audit_migration'

class AuditUsersTable < ActiveRecord::Migration[5.2]
  def up
    migration = AuditMigration.new('user')
    execute(migration.create_table)
    execute(migration.create_trigger)
  end

  def down
    migration = AuditMigration.new('user')
    execute(migration.drop)
  end
end
