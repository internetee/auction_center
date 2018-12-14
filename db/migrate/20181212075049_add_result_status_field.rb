class AddResultStatusField < ActiveRecord::Migration[5.2]
  def up
    sql = <<~SQL
      CREATE TYPE result_status AS ENUM('expired', 'sold', 'paid');
    SQL

    execute(sql)

    remove_column :results, :sold
    add_column :results, :status, :result_status, null: false, index: true
  end

  def down
    remove_column :results, :status

    sql = <<~SQL
      DROP TYPE result_status;
    SQL

    execute(sql)
  end
end
