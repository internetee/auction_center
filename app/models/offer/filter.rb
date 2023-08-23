module Offer::Filter
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
  end
end
