class DropLegalEntityField < ActiveRecord::Migration[5.2]
  def change
    remove_column :billing_profiles, :legal_entity
  end
end
