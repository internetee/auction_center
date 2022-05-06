class EnglishBidsPresenter
  include ActionView::Helpers::TagHelper

  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def maximum_bids
    return 'Bad auction type' if auction.platform == 'blind'
    return auction.starting_price if auction.offers.empty?

    Money.new(auction.offers.maximum(:cents), Setting.find_by(code: 'auction_currency').retrieve)
  end

  def display_ends_at
    return 'Bad auction type' if auction.platform == 'blind'

    return auction.ends_at if auction.offers.empty?

    auction.offers.order(created_at: :desc).first.created_at + auction.slipping_end.minutes + 1.minute
  end
end
