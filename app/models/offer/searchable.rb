module Offer::Searchable
  extend ActiveSupport::Concern

  included do
    scope :filter_by_domain_name, -> {
      includes(:auction).where("auctions.domain_name LIKE ?", "%#{params[:domain_name]}%")
    }
  end

  class_methods do
    def search(params = {})
      sort_by = params[:sort_by] || 'offers.created_at'
      sort_direction = params[:sort_direction] || 'desc'

      reorder("#{sort_by} #{sort_direction}")
    end

    def highest_per_auction_for_user(user_id)
      # Use a subquery to get highest offers per auction, then order by created_at
      subquery = joins(:auction)
        .select('DISTINCT ON (auctions.id) offers.id')
        .where(user_id: user_id)
        .order('auctions.id, offers.cents DESC')

      where(id: subquery)
        .joins(:auction)
        .select('offers.*, auctions.domain_name, auctions.platform, auctions.ends_at')
        .order('offers.created_at DESC')
    end
  end
end
