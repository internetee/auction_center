require 'audit_migration'

class AuditWishlistItemTable < ActiveRecord::Migration[5.2]
  def up
    migration = AuditMigration.new('wishlist_item')
    execute(migration.create_table)
    execute(migration.create_trigger)
  end

  def down
    migration = AuditMigration.new('wishlist_item')
    execute(migration.drop)
  end
end
