class CreateBankTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_transactions do |t|
      t.references :bank_statement
      t.string :bank_reference
      t.string :iban
      t.string :currency
      t.string :buyer_bank_code
      t.string :buyer_iban
      t.string :buyer_name
      t.string :document_no
      t.string :description
      t.decimal :sum
      t.string :reference_no
      t.datetime :paid_at

      t.timestamps
    end
  end
end
