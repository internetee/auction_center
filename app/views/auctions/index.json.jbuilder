json.array! @auctions_list do |auction|
  json.domain_name auction.domain_name
  json.starts_at auction.starts_at.utc
  json.ends_at auction.ends_at.utc
  json.auction_type auction&.platform
  json.id auction.uuid
  json.highest_bid auction.currently_winning_offer&.price.to_f
  json.highest_bidder auction.currently_winning_offer&.username
  json.min_bids_step auction.min_bids_step.to_f
  json.auction_type auction&.platform
end
