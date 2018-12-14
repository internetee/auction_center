require 'audit_migration'

class AuditPaymentOrdersTable < ActiveRecord::Migration[5.2]
  def up
    migration = AuditMigration.new('payment_order')
    execute(migration.create_table)
    execute(migration.create_trigger)
  end

  def down
    migration = AuditMigration.new('payment_order')
    execute(migration.drop)
  end
end
