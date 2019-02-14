class AddLastReportedStatusColumnToResult < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_column :results, :last_reported_status, :result_status
    add_column :results, :last_response, :jsonb
    add_column :results, :registration_code, :string

    add_index :results, :last_reported_status, algorithm: :concurrently
  end
end
