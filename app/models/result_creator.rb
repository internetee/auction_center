class ResultCreator
  attr_reader :auction_id
  attr_reader :auction
  attr_reader :result
  attr_reader :winning_offer

  def initialize(auction_id)
    @auction_id = auction_id
  end

  def call
    @auction = Auction.find_by(id: auction_id)

    return unless auction_present?
    return if auction_not_finished?
    return auction.result if result_already_present?

    @winning_offer = auction.currently_winning_offer || NullOffer.new

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

  def assign_attributes_from_winning_offer
    result.offer_id = winning_offer.id
    result.user_id = winning_offer.user_id
  end

  def assign_status
    sold = winning_offer.cents &&
           winning_offer.user_id &&
           winning_offer.billing_profile_id

    result.status = if sold
                      Result.statuses[:awaiting_payment]
                    else
                      Result.statuses[:no_bids]
                    end
  end

  def create_result
    @result = Result.new
    result.auction = auction
    assign_status
    assign_attributes_from_winning_offer
    result.save!

    result
  end
end
