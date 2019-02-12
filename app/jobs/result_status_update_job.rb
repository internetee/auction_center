class ResultStatusUpdateJob < ApplicationJob
  def perform
    Result.pending_remote_update.map do |result|
      ResultStatusReporter.new(result).call
    end
  end
end
