# rubocop:disable Metrics
class WishlistItemsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :authenticate_user!
  before_action :check_for_action_restrictions, only: %i[create update]
  before_action :set_wishlist_item, only: %i[edit update destroy]
  before_action :set_wishlist_items, only: %i[index update edit destroy]

  rescue_from ActiveModel::RangeError, with: :out_of_range_handle

  def index
    @wishlist_item = WishlistItem.new(user: current_user)
  end

  def edit
    return unless turbo_frame_request?

    render partial: 'editable', locals: { wishlist_items: @wishlist_items, wishlist_item: @wishlist_item }
  end

  def create
    @wishlist_item = WishlistItem.new(strong_params)

    respond_to do |format|
      if create_predicate
        format.html { redirect_to wishlist_items_path, notice: t(:created) }
        format.json { render json: @wishlist_item, status: :created }
      else
        format.json { render json: @wishlist_item.errors.full_messages, status: :unprocessable_entity }
        format.html { redirect_to wishlist_items_path, notice: @wishlist_item.errors.full_messages.join(', ') }
      end
    end
  end

  def destroy
    authorize! :delete, @wishlist_item

    respond_to do |format|
      if @wishlist_item.destroy
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('flash', partial: 'common/flash', locals: { flash: }),
            turbo_stream.update('wishlist-container', partial: 'wishlist_items',
                                                      locals: { wishlist_items: @wishlist_items })
          ]
        end
        format.html { redirect_to wishlist_items_path, notice: t(:created) }
        format.json { render json: @wishlist_item, status: :created }
      else
        format.json { render json: @wishlist_item.errors.full_messages, status: :unprocessable_entity }
        format.html { redirect_to wishlist_items_path, notice: @wishlist_item.errors.full_messages.join(', ') }
      end
    end
  end

  def update
    if @wishlist_item.update(strong_params)
      flash[:notice] = t(:updated)
      render turbo_stream: [
        turbo_stream.replace('flash', partial: 'common/flash', locals: { flash: }),
        turbo_stream.update('wishlist-container', partial: 'wishlist_items',
                                                  locals: { wishlist_items: @wishlist_items })
      ]
    else
      flash[:alert] = @wishlist_item.errors.full_messages.join(', ')

      render turbo_stream: [
        turbo_stream.replace('flash', partial: 'common/flash', locals: { flash: })
      ]
    end
  end

  # this method used by wishlist stimulus controller
  def domain_wishlist_availability
    wishlist_item = current_user.wishlist_items.build(domain_name: params[:domain_name])
    msg = if wishlist_item.valid?
            { status: 'fine', domain_name: params[:domain_name] }
          else
            { status: 'wrong', domain_name: params[:domain_name], errors: wishlist_item.errors.full_messages }
          end

    render json: msg
  end

  private

  def create_predicate
    authorize! :create, @wishlist_item
    @wishlist_item.save
  end

  def out_of_range_handle(exception)
    flash[:alert] = exception

    render turbo_stream: [
      turbo_stream.replace('flash', partial: 'common/flash', locals: { flash: })
    ]
  end

  def set_wishlist_item
    @wishlist_item = WishlistItem.for_user(current_user).find_by(uuid: params[:uuid])
  end

  def set_wishlist_items
    @wishlist_items = WishlistItem.for_user(current_user.id)
  end

  def check_for_action_restrictions
    if current_user.completely_banned?
      I18n.t('auctions.banned_completely', valid_until: current_user.longest_ban.valid_until)
    elsif current_user.bans.valid.pluck(:domain_name).include?(params[:domain_name])
      I18n.t('auctions.banned', domain_names: params[:domain_name])
    end
  end

  def strong_params
    params.require(:wishlist_item).permit(:user_id, :domain_name, :price)
  end
end
