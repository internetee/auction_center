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
    problematic_auctions = []
    skipped_auctions = []
    auctions.each do |auction|
      if skip?(auction)
        skipped_auctions << auction.domain_name

        next
      end

      auction = apply_values(auction)

      if auction.save
        FirstBidFromWishlistService.apply_bid(auction: auction)
      else
        problematic_auctions << wrap_problematic_auction(auction)
      end
    end

    [skipped_auctions, problematic_auctions]
  end

  def wrap_problematic_auction(auction)
    Struct.new(:name, :errors).new(auction.domain_name, auction.errors.full_messages)
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
    auction.starts_at = auction_elements[:set_starts_at] if auction_elements[:set_starts_at].present?
    auction.ends_at = auction_elements[:set_ends_at] if auction_elements[:set_ends_at].present?
    auction.initial_ends_at = auction_elements[:set_ends_at] if auction_elements[:set_ends_at].present?
    auction.starting_price = auction_elements[:starting_price] if auction_elements[:starting_price].present?
    auction.min_bids_step = auction.starting_price if auction_elements[:starting_price].present?
    auction.slipping_end = auction_elements[:slipping_end] if auction_elements[:slipping_end].present?
    auction.deposit = auction_elements[:deposit] unless auction_elements[:deposit].to_f.zero?

    auction = deposit_handler(auction)

    auction.skip_broadcast = true if auction.starts_at.nil? || Time.zone.now < auction.starts_at

    # auction.save!
    auction
  end

  def deposit_handler(auction)
    return auction unless auction.english?

    auction.enable_deposit = true if auction_elements[:enable_deposit].present?
    if auction_elements[:disable_deposit].present?
      auction.enable_deposit = false
      auction.deposit = 0
    end

    auction
  end
end
