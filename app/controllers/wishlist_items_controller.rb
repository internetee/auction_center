class WishlistItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @wishlist_item = WishlistItem.new(user: current_user)
    @wishlist_items = WishlistItem.for_user(current_user.id)
                                  # .page(params[:page])
                                  # .order(created_at: :desc)
  end

  def create
    @wishlist_item = WishlistItem.new(strong_params)

    respond_to do |format|
      if create_predicate
        format.html { redirect_to wishlist_items_path, notice: t(:created) }
        format.json { render json: @wishlist_item, status: :created }
      else
        format.json do
          render json: @wishlist_item.errors.full_messages, status: :unprocessable_entity
        end
        format.html { redirect_to wishlist_items_path, notice: t(:something_went_wrong) }
      end
    end
  end

  def destroy
    @wishlist_item = WishlistItem.for_user(current_user).find_by(uuid: params[:uuid])
    authorize! :delete, @wishlist_item
    @wishlist_item.destroy

    respond_to do |format|
      format.html { redirect_to wishlist_items_path, notice: t(:deleted) }
      format.json { head :no_content }
    end
  end

  def create_predicate
    authorize! :create, @wishlist_item
    @wishlist_item.save
  end

  def update
    wishlist_item = WishlistItem.find_by(uuid: params[:uuid])
    domain_name = wishlist_item.domain_name

    if current_user.completely_banned?
      flash[:alert] = I18n.t('auctions.banned_completely', valid_until: current_user.longest_ban.valid_until)
      redirect_to wishlist_items_path and return
    end

    if current_user.bans.valid.pluck(:domain_name).include?(domain_name)
      flash[:alert] = I18n.t('auctions.banned', domain_names: domain_name)
      redirect_to wishlist_items_path and return
    end

    if wishlist_item.update(strong_params)
      flash[:notice] = 'Updated'
    else
      flash[:alert] = I18n.t('something_went_wrong')
    end

    redirect_to wishlist_items_path
  end

  private

  def strong_params
    params.require(:wishlist_item).permit(:user_id, :domain_name, :price)
  end
end
