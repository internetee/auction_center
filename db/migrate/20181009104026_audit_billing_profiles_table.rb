require 'audit_migration'

class AuditBillingProfilesTable < ActiveRecord::Migration[5.2]
  def up
    migration = AuditMigration.new('billing_profile')
    execute(migration.create_table)
    execute(migration.create_trigger)
  end

  def down
    migration = AuditMigration.new('billing_profile')
    execute(migration.drop)
  end
end
