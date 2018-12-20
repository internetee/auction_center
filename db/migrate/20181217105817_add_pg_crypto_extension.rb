class AddPgCryptoExtension < ActiveRecord::Migration[5.2]
  def up
    sql = <<~SQL
      CREATE EXTENSION IF NOT EXISTS pgcrypto;
    SQL

    execute(sql)
  end

  def down
    sql = <<~SQL
      DROP EXTENSION IF EXISTS pgcrypto;
    SQL

    execute(sql)
  end
end
