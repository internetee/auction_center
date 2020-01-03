select results.id, auctions.domain_name as domain_name, results.created_at,
       auctions.ends_at as auction_ends_at, results.status
from results join auctions on results.auction_id = auctions.id
group by results.id, auctions.domain_name, auctions.ends_at
