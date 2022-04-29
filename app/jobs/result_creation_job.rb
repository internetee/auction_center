class ResultCreationJob < ApplicationJob
  def perform
    Auction.without_result_and_slipping_left.map do |auction|
      Result.create_from_auction(auction.id)
    end

    InvoiceCreationJob.perform_later
  end

  def self.needs_to_run?
    Auction.without_result.any?
  end
end
