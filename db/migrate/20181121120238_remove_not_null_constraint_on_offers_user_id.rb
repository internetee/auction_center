class RemoveNotNullConstraintOnOffersUserId < ActiveRecord::Migration[5.2]
  def change
    change_column_null :offers, :user_id, true
  end
end
