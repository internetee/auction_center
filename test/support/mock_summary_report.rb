# Used for email previews
class MockSummaryReport < SummaryReport
  attr_writer :winning_offers
  attr_writer :results_with_no_bids
  attr_writer :registration_deadlines
  attr_writer :bans

  def results_with_no_bids
    @results_with_no_bids ||= []
  end

  def winning_offers
    @winning_offers ||= []
  end

  def registration_deadlines
    @registration_deadlines ||= []
  end

  def bans
    @bans ||= []
  end
end
