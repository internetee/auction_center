class CreateBankStatements < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_statements do |t|
      t.string :bank_code
      t.string :iban
      t.datetime :queried_at

      t.timestamps
    end
  end
end
