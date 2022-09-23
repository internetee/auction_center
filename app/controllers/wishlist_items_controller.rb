class WishlistItemsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :authenticate_user!

  def index
    @wishlist_item = WishlistItem.new(user: current_user)
    @wishlist_items = WishlistItem.for_user(current_user.id)
  end

  def edit
    @wishlist_item = WishlistItem.find_by(uuid: params[:uuid])
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

    flash[:alert] = check_for_action_restrictions(wishlist_item.domain_name)
    redirect_to wishlist_items_path and return if flash[:alert].present?

    respond_to do |format|
      if wishlist_item.update(strong_params)
        flash.now[:notice] = 'Updated'
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append(dom_id(wishlist_item), partial: 'wishlist_items/starting_price',
                                                       locals: { wishlist_item: wishlist_item })
          ]
        end
      else
        flash[:alert] = I18n.t('something_went_wrong')
        format.html { redirect_to wishlist_items_path }
      end
    end
  end

  # this method used by wishlist stimulus controller
  def domain_wishlist_availability
    wishlist_item = current_user.wishlist_items.build(domain_name: params[:domain_name])
    if wishlist_item.valid?
      msg = { status: 'fine', domain_name: params[:domain_name] }
    else
      msg = { status: 'wrong', domain_name: params[:domain_name], errors: wishlist_item.errors.full_messages }
    end

    render json: msg
  end

  private

  def check_for_action_restrictions(domain_name)
    if current_user.completely_banned?
      I18n.t('auctions.banned_completely', valid_until: current_user.longest_ban.valid_until)
    elsif current_user.bans.valid.pluck(:domain_name).include?(domain_name)
      I18n.t('auctions.banned', domain_names: domain_name)
    end
  end

  def strong_params
    params.require(:wishlist_item).permit(:user_id, :domain_name, :price)
  end
end
