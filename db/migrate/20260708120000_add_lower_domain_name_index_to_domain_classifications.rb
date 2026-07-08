class AddLowerDomainNameIndexToDomainClassifications < ActiveRecord::Migration[8.1]
  # The /auctions user-sorting join matches on LOWER(domain_classifications.domain_name)
  # (see Auction::UserSortable). The plain btree on domain_name can't serve a
  # LOWER() predicate, so every logged-in /auctions load seq-scanned this table.
  # A functional index on LOWER(domain_name) restores index usage on that join.
  def change
    add_index :domain_classifications, 'LOWER(domain_name)',
              name: 'index_domain_classifications_on_lower_domain_name'
  end
end
