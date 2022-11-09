class EnglishBidsPresenter
  include ActionView::Helpers::TagHelper

  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def last_actual_offer
    auction.offers.order(updated_at: :desc).first
  end

  def maximum_bids
    return 'Bad auction type' if auction.platform == 'blind'
    return 0.0 if auction.offers.empty?

    Money.new(last_actual_offer.cents, Setting.find_by(code: 'auction_currency').retrieve)
  end

  def display_ends_at
    return 'Bad auction type' if auction.platform == 'blind'

    return auction.ends_at if auction.offers.empty?

    auction.offers.order(created_at: :desc).first.created_at + auction.slipping_end.minutes + 1.minute
  end
end
