module Wishlists
  class DomainValiditiesController < ApplicationController
    def show
      wishlist_item = current_user.wishlist_items.build(domain_name: params[:domain_name])

      msg = if wishlist_item.valid?
              { status: 'fine', domain_name: params[:domain_name], message: I18n.t('wishlist_items.suitable_domain') }
            else
              { status: 'wrong', domain_name: params[:domain_name], errors: wishlist_item.errors.full_messages }
            end

      render json: msg
    end
  end
end
