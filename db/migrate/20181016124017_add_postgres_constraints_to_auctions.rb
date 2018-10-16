class AddPostgresConstraintsToAuctions < ActiveRecord::Migration[5.2]
  def up
    sql = <<~SQL
      CREATE EXTENSION btree_gist;

      ALTER TABLE public.auctions
      ADD CONSTRAINT starts_at_earlier_than_ends_at CHECK (starts_at < ends_at);


      ALTER TABLE public.auctions
      ADD CONSTRAINT unique_domain_name_per_auction_duration EXCLUDE USING gist (
        domain_name WITH =,
        tsrange(starts_at, ends_at, '[]') WITH &&
      )
    SQL

    execute(sql)
  end

  def down
    sql = <<~SQL
      ALTER TABLE public.auctions DROP CONSTRAINT starts_at_earlier_than_ends_at;
      ALTER TABLE public.auctions DROP CONSTRAINT unique_domain_name_per_auction_duration;
      DROP EXTENSION IF EXISTS btree_gist
    SQL

    execute(sql)
  end
end
