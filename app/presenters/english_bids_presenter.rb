class EnglishBidsPresenter
  include ActionView::Helpers::TagHelper

  attr_reader :auction, :current_user

  def initialize(auction, current_user)
    @auction = auction
    @current_user = current_user
  end

  def get_last_actual_offer
    auction.offers.order(updated_at: :desc).first
  end

  def maximum_bids
    return 'Bad auction type' if auction.platform == 'blind'
    # return auction.starting_price if auction.offers.empty?
    return 0.0 if auction.offers.empty?

    offer = get_last_actual_offer

    Money.new(offer.cents, Setting.find_by(code: 'auction_currency').retrieve)
  end

  def do_current_user_offer?
    offer = get_last_actual_offer

    offer.user == current_user
  end

  def display_ends_at
    return 'Bad auction type' if auction.platform == 'blind'

    return auction.ends_at if auction.offers.empty?

    auction.offers.order(created_at: :desc).first.created_at + auction.slipping_end.minutes + 1.minute
  end
end
