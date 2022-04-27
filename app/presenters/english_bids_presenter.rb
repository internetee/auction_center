class EnglishBidsPresenter
  include ActionView::Helpers::TagHelper

  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def maximum_bids
    return 'Bad auction type' if auction.platform == 'blind'

    auction.maximum_bids.nil? ? auction.starting_price : auction.maximum_bids
  end
end
