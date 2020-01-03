class CreateRemoteViewPartials < ActiveRecord::Migration[5.2]
  def change
    create_table :remote_view_partials do |t|
      t.string :name, null: false
      t.string :locale, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
