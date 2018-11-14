class ResultCreator
  attr_reader :auction_id
  attr_reader :auction
  attr_reader :result

  def initialize(auction_id)
    @auction_id = auction_id
  end

  def call
    @auction = Auction.find_by(id: auction_id)

    return unless auction_present?
    return if auction_not_finished?
    return auction.result if result_already_present?

    create_result
    send_email_to_winner
    result
  end

  private

  delegate :present?, to: :auction, prefix: true

  def auction_not_finished?
    !auction.finished?
  end

  def result_already_present?
    auction.result.present?
  end

  def send_email_to_winner
    result.send_email_to_winner
  end

  def create_result
    @result = Result.new
    winning_offer = auction.winning_offer || NullOffer.new

    result.auction = auction
    result.user = winning_offer.user
    result.cents = winning_offer.cents
    result.sold = (winning_offer.cents && winning_offer.user) || false

    result.save!

    result
  end
end
