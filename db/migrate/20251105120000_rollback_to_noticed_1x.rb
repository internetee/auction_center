class RollbackToNoticed1x < ActiveRecord::Migration[7.0]
  def up
    drop_table :noticed_notifications if table_exists?(:noticed_notifications)
    drop_table :noticed_events if table_exists?(:noticed_events)

    execute 'DELETE FROM notifications'

    say 'Noticed 2.x tables removed and notifications cleared'
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'Cannot restore Noticed 2.x tables and old notifications'
  end
end
