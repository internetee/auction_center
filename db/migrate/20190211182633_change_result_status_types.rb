class ChangeResultStatusTypes < ActiveRecord::Migration[5.2]
  def up
    remove_column :results, :status

    sql = <<~SQL
      DROP TYPE result_status;
    SQL

    execute(sql)

    sql = <<~SQL
      CREATE TYPE result_status AS ENUM(
        'no_bids', 'awaiting_payment', 'payment_received',
        'payment_not_received', 'domain_registered', 'domain_not_registered'
      );
    SQL

    execute(sql)

    add_column :results, :status, :result_status, index: true
  end

  def down
    remove_column :results, :status

    sql = <<~SQL
      DROP TYPE result_status;
    SQL

    execute(sql)
  end
end
