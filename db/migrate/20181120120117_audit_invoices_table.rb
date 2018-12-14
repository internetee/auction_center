require 'audit_migration'

class AuditInvoicesTable < ActiveRecord::Migration[5.2]
  def up
    migration = AuditMigration.new('invoice')
    execute(migration.create_table)
    execute(migration.create_trigger)
  end

  def down
    migration = AuditMigration.new('invoice')
    execute(migration.drop)
  end
end
