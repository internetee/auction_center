class CleanNotificationParamsFromReservedKeys < ActiveRecord::Migration[7.0]
  def up
    # Clean existing notifications params from ActiveJob reserved keys
    execute <<-SQL
      UPDATE notifications
      SET params = (
        SELECT jsonb_object_agg(key, value)
        FROM jsonb_each(params)
        WHERE key NOT IN ('_aj_globalid', '_aj_serialized')
      )
      WHERE params ?| array['_aj_globalid', '_aj_serialized']
    SQL

    say "Cleaned #{Notification.where("params ?| array['_aj_globalid', '_aj_serialized']").count} notifications"
  end

  def down
    # No rollback needed - we're only removing corrupted data
    say "Cannot rollback - reserved keys were removed for data integrity"
  end
end
