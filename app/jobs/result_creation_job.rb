class ResultCreationJob < ApplicationJob
  def perform
    Auction.without_result.map do |auction|
      Result.create_from_auction(auction.id)
    end
  end
end
