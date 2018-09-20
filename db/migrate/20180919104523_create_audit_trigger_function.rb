require 'audit_migration'

class CreateAuditTriggerFunction < ActiveRecord::Migration[5.2]
  def up
    sql = <<~SQL
      CREATE SCHEMA IF NOT EXISTS audit;
      SQL
    execute(sql)

    migration = AuditMigration.new('user')
    execute(migration.create_table)
    execute(migration.create_trigger)
  end

  def down
    migration = AuditMigration.new('user')
    execute(migration.drop)

    sql = <<~SQL
      DROP SCHEMA IF EXISTS audit;
    SQL

    execute(sql)
  end
end
