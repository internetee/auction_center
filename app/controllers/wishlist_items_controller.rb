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
        # user = @wishlist_item.user
        # auction = Auction.find_by(domain_name: @wishlist_item.domain_name)
        # if auction && auction.in_progress?
        #   EnglishAutobiderJob.perform_now(auction.id, user.id)
        #   # && auction.offers.last.user == user
        #   # или обновить или создать оффер
        #   # offer = Offer.Offer.find_by(auction_id: auction.id, user_id: user.id)
        # end

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

    # highest_bid = strong_params[:maximum_bid] || 0
    # highest_bid = Money.from_amount(highest_bid.to_d, Setting.find_by(code: 'auction_currency').retrieve)
    # highest_bid = highest_bid.cents.positive? ? highest_bid.cents : nil
    # starting_price = wishlist_item.cents || 0

    # if highest_bid.to_i < starting_price
    #   flash[:alert] = "Highest bid can't be less than starting price!"
    #   redirect_to wishlist_items_path and return
    # end

    if wishlist_item.update(strong_params)
      # make_autobid(wishlist_item: wishlist_item)
      flash[:notice] = 'Updated'
    else
      flash[:alert] = I18n.t('something_went_wrong')
    end

    redirect_to wishlist_items_path
  end

  private

  # def make_autobid(wishlist_item:)
  #   auction = Auction.find_by(domain_name: wishlist_item.domain_name)

  #   if auction && auction.in_progress?
  #     user = wishlist_item.user
  #     last_offer = Offer.where(auction_id: auction.id).order(updated_at: :asc).last
  #     return if last_offer.present? && last_offer.user == user
  #     return if wishlist_item.highest_bid.nil? && wishlist_item.cents.nil?

  #     if wishlist_item.highest_bid.nil? && wishlist_item.cents.present?
  #       # assign started price
  #     elsif wishlist_item.highest_bid.present?
  #       increase_to_possible_higher_bid(auction: auction, user: user, wishlist_item: wishlist_item)
  #     end
  #   end
  # end

  # def increase_to_possible_higher_bid(auction:, user:, wishlist_item:)
  #   user_offer = Offer.where(auction_id: auction.id, user_id: user.id)
  #   min_bid_step = auction.min_bids_step
  #   min_bid_step_translated = Money.from_amount(min_bid_step.to_d, Setting.find_by(code: 'auction_currency').retrieve)

  #   return if min_bid_step_translated.cents > wishlist_item.highest_bid

  #   if user_offer.empty?
  #     Offer.create!(
  #       auction: auction,
  #       user: user,
  #       cents: min_bid_step_translated.cents,
  #       billing_profile: user.billing_profiles.first
  #     )
  #   else
  #     user_offer.last.update(cents: min_bid_step_translated.cents)
  #   end

  #   auction.update_minimum_bid_step(min_bid_step)
  # end

  def strong_params
    params.require(:wishlist_item).permit(:user_id, :domain_name, :price)
  end
end
