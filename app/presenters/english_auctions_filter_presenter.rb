class EnglishAuctionsFilterPresenter
  include ActionView::Helpers::TagHelper

  attr_reader :auctions

  def initialize(auctions)
    @auctions = auctions
  end

  def return_filtred_collection
    auction_collection = []
    auctions.english.each do |auction|
      auction_collection << auction if auction.starts_at.nil?

      auction_collection << auction if !auction.ends_at.nil? && auction.ends_at > Time.zone.now
    end

    Auction.with_highest_offers.not_english.each do |auction|
      auction_collection << auction if !auction.ends_at.nil? && auction.ends_at > Time.zone.now
    end

    auction_collection.uniq
  end
end
