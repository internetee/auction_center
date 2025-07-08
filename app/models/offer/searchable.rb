module Offer::Searchable
  extend ActiveSupport::Concern

  included do
    scope :filter_by_domain_name, -> {
      includes(:auction).where("auctions.domain_name LIKE ?", "%#{params[:domain_name]}%")
    }
  end

  class_methods do
    def search(params = {})
      sort_by = params[:sort_by] || 'created_at'
      sort_direction = params[:sort_direction] || 'desc'

      includes(:auction).order("#{sort_by} #{sort_direction}")
    end

    def highest_per_auction_for_user(user_id, params = {})
      # Get highest offer for each auction
      joins(:auction)
        .select('DISTINCT ON (auctions.id) offers.*, auctions.domain_name, auctions.platform, auctions.ends_at')
        .where(user_id:)
        .order('auctions.id, offers.cents DESC')
        .search(params)
    end
  end
end
