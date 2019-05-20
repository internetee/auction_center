class WishlistItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @wishlist_item = WishlistItem.new(user: current_user)
    @wishlist_items = WishlistItem.for_user(current_user.id)
                                  .page(params[:page])
                                  .order(created_at: :desc)
  end

  def create
    @wishlist_item = WishlistItem.new(create_params)
    authorize! :create, @wishlist_item

    respond_to do |format|
      if @wishlist_item.save
        format.html { redirect_to wishlist_items_path, notice: t(:created) }
        format.json { render json: @wishlist_item, status: :created }
      else
        format.json do
        format.html { redirect_to wishlist_items_path, notice: t(:something_went_wrong) }
          render json: @wishlist_item.errors.full_messages, status: :unprocessable_entity
        end
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

  private

  def create_params
    params.require(:wishlist_item).permit(:user_id, :domain_name)
  end
end
