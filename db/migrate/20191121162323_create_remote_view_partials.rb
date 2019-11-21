class CreateRemoteViewPartials < ActiveRecord::Migration[5.2]
  def change
    create_table :remote_view_partials do |t|
      t.string :name
      t.text :content

      t.timestamps
    end
  end
end
