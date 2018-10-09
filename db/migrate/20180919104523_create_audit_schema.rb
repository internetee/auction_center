require 'audit_migration'

class CreateAuditSchema < ActiveRecord::Migration[5.2]
  def up
    sql = <<~SQL
      CREATE SCHEMA IF NOT EXISTS audit;
      SQL
    execute(sql)
  end

  def down
    sql = <<~SQL
      DROP SCHEMA IF EXISTS audit;
    SQL

    execute(sql)
  end
end
