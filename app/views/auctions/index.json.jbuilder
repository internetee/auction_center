json.array! @auctions do |auction|
  json.domain_name auction.domain_name
  json.starts_at auction.starts_at.utc
  json.ends_at auction.ends_at.utc
  json.id auction.uuid
end
