# Legacy footer cache filled by the removed SharedFooterFetcherJob.
# The footer is now rendered by the voog_footer gem.
class DropRemoteViewPartials < ActiveRecord::Migration[8.1]
  def change
    drop_table :remote_view_partials do |t|
      t.string :name, null: false
      t.string :locale, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
