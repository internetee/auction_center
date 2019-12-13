select auctions.id, domain_name, auctions.created_at, starts_at, ends_at,
       offers.count as offers_count,
       (EXISTS (select * from results where results.auction_id = auctions.id)) as completed
from auctions left outer join offers on auctions.id = offers.auction_id
group by auctions.id
