class AdminBulkActionService
  attr_reader :auction_elements

  def initialize(auction_elements:)
    @auction_elements = auction_elements
  end

  def self.apply_for_english_auction(auction_elements:)
    admin_handler = new(auction_elements: auction_elements)
    admin_handler.apply_english_auction
  end

  def apply_english_auction
    return if parse_auction_ids.nil?

    auctions = Auction.where(id: parse_auction_ids)
    skipped_auctions = []
    auctions.each do |auction|
      if skip?(auction)
        skipped_auctions << auction.domain_name

        next
      end

      apply_values(auction)
      FirstBidFromWishlistService.apply_bid(auction: auction)
    end

    skipped_auctions
  end

  def parse_auction_ids
    auction_ids = auction_elements[:auction_ids]
    auction_ids = auction_elements[:elements_id].split(' ') if auction_ids.nil?

    auction_ids
  end

  def skip?(auction)
    !auction.starts_at.nil? && auction.starts_at < Time.zone.now || !auction.english?
  end

  def apply_values(auction)
    auction.starts_at = auction_elements[:set_starts_at] unless auction_elements[:set_starts_at].empty?
    auction.ends_at = auction_elements[:set_ends_at] unless auction_elements[:set_ends_at].empty?
    auction.initial_ends_at = auction_elements[:set_ends_at] unless auction_elements[:set_ends_at].empty?
    auction.starting_price = auction_elements[:starting_price] unless auction_elements[:starting_price].empty?
    auction.min_bids_step = auction.starting_price unless auction_elements[:starting_price].empty?
    auction.slipping_end = auction_elements[:slipping_end] unless auction_elements[:slipping_end].empty?
    auction.deposit = auction_elements[:deposit] unless auction_elements[:deposit].zero?

    auction = deposit_handler(auction)
    auction.save!
  end

  def deposit_handler(auction)
    return auctiom unless auction.english?

    auction.enable_deposit = true if auction_elements[:enable_deposit].present?
    auction.enable_deposit = false if auction_elements[:disable_deposit].present?

    auction
  end
end
