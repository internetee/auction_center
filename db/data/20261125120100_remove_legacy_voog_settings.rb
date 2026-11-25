# frozen_string_literal: true

# Settings used by the removed SharedFooterFetcherJob. The voog_footer gem
# reads its configuration from customization.yml instead.
class RemoveLegacyVoogSettings < ActiveRecord::Migration[8.1]
  CODES = %w[voog_api_key voog_site_url voog_site_fetching_enabled].freeze

  def up
    Setting.where(code: CODES).delete_all
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
