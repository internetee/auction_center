class ResultCreationJob < ApplicationJob
  def perform
    Auction.without_result.map do |auction|
      Result.create_from_auction(auction.id)
    end

    InvoiceCreationJob.perform_later
  end

  def self.needs_to_run?
    Auction.without_result.any?
  end
end
