class AddResultRegistrationDateColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :results, :registration_due_date, :date
    Result.all.update(registration_due_date: Date.today + Setting.registration_term)
    change_column_null :results, :registration_due_date, false
  end
end
