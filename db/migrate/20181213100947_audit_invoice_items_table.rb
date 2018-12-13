require 'audit_migration'

class AuditInvoiceItemsTable < ActiveRecord::Migration[5.2]
  def up
    migration = AuditMigration.new('invoice_item')
    execute(migration.create_table)
    execute(migration.create_trigger)
  end

  def down
    migration = AuditMigration.new('invoice_item')
    execute(migration.drop)
  end
end
